{
  lib,
  callPackage,
  stdenv,
  ncurses5,
  bc,
  bubblewrap,
  autoPatchelfHook,
  python3,
  libgcc,
  glibc,
  writeShellScript,
  writeText,
  writeTextFile,

  # For the updater script
  writeShellApplication,
  curl,
  jq,
  htmlq,
  common-updater-scripts,
  writableTmpDirAsHomeHook,
}:

{
  mkIntelOneApi = lib.extendMkDerivation {
    constructDrv = stdenv.mkDerivation;

    excludeDrvArgNames = [
      "depsByComponent"
      "components"
    ];

    extendDrvArgs =
      fa:
      {
        pname,
        versionYear,
        versionMajor,
        versionMinor,
        versionRel,
        src,
        meta,
        depsByComponent ? { },
        postInstall ? "",
        components ? [ "default" ],
        ...
      }@args:
      let
        shortName = name: builtins.elemAt (lib.splitString "." name) 3;
      in
      {
        version = "${fa.versionYear}.${fa.versionMajor}.${fa.versionMinor}.${fa.versionRel}";

        nativeBuildInputs = [
          # Installer wants tput
          ncurses5
          # Used to check if there's enough disk space
          bc
          bubblewrap

          autoPatchelfHook
          writableTmpDirAsHomeHook
        ];

        buildInputs = [
          # For patchShebangs
          python3
        ]
        # autoPatchelfHook will add these libraries to RPATH as required
        ++ lib.concatMap (
          comp:
          if comp == "all" || comp == "default" then
            lib.concatLists (builtins.attrValues depsByComponent)
          else
            depsByComponent.${shortName comp} or [ ]
        ) components;

        phases = [
          "installPhase"
          "fixupPhase"
        ];

        # See https://software.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top/installation/install-with-command-line.html
        installPhase = ''
          runHook preInstall
          # The installer expects that the installation directory is already present
          mkdir -p "$out"

          # Required for the installer to find libstdc++
          export LD_LIBRARY_PATH="${lib.makeLibraryPath [ libgcc.lib ]}"

          # The installer is an insane four-stage rube goldberg machine:
          # 1. Our $src (bash script) unpacks install.sh (bash script)
          # 2. install.sh unpacks bootstrapper (dylinked binary with hardcoded interpreter in /lib)
          # 3. bootstrapper unpacks installer (dylinked binary with hardcoded interpreter and libraries in /lib)
          # 4. installer installs the actual components we need
          #
          # While stage 1 allows to "only extract", other stages always try running the next executable down, and remove stuff if they fail.
          # I'm afraid this is the cleanest solution for now.
          mkdir -p fhs-root/{lib,lib64}
          ln -s "${glibc}/lib/"* fhs-root/lib/
          ln -s "${glibc}/lib/"* fhs-root/lib64/
          bwrap \
            --bind fhs-root / \
            --bind /nix /nix \
            --ro-bind /bin /bin \
            --dev /dev \
            --proc /proc \
            bash "$src" \
              -a \
              --silent \
              --eula accept \
              --install-dir "$out" \
              --components ${lib.concatStringsSep ":" components}

          # Non-reproducible
          rm -rf "$out"/logs
          # This contains broken symlinks and doesn't seem to be useful
          rm -rf "$out"/.toolkit_linking_tool

          ln -s "$out/$versionYear.$versionMajor"/{lib,etc,bin,share,opt} "$out"

          runHook postInstall
        '';
      };
  };

  mkUpdateScript =
    {
      pname,
      downloadPage,
      file,
    }:
    writeShellApplication {
      name = "update-intel-oneapi";
      runtimeInputs = [
        curl
        jq
        htmlq
        common-updater-scripts
      ];
      text = ''
        download_page=${lib.escapeShellArg downloadPage}
        pname=${lib.escapeShellArg pname}
        nixpkgs="$(git rev-parse --show-toplevel)"
        packageDir="$nixpkgs/pkgs/by-name/in/intel-oneapi"
        file="$packageDir"/${lib.escapeShellArg file}

        echo 'Figuring out the download URL' >&2

        # Intel helpfully gives us a wget command to run so that we can download the toolkit installer, as part of their product page.
        # This variable will contain that command (wget https://...), we will extract the URL from it.
        wget_command="$(curl "$download_page" \
          | htmlq 'code' --text \
          | grep "wget.*$pname.*sh")"

        regex="wget (.*$pname.([0-9]+)[.]([0-9]+)[.]([0-9]+)[.]([0-9]+)_offline[.]sh)"
        if [[ "$wget_command" =~ $regex ]]; then
            url="''${BASH_REMATCH[1]}"
            versionYear="''${BASH_REMATCH[2]}"
            versionMajor="''${BASH_REMATCH[3]}"
            versionMinor="''${BASH_REMATCH[4]}"
            versionRel="''${BASH_REMATCH[5]}"
        else
            echo "'$wget_command' does not match the expected format $regex" >&2
            exit 1
        fi

        if [[ "$(grep 'url =' "$file")" =~ "$url" ]] && [[ "''${BASH_REMATCH[0]}" == "$url" ]]; then
            echo "The URL is the same ($url), skipping update" >&2
        else
            echo "The new download URL is $url, prefetching it to store" >&2
            hash="$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url --quiet "$url")")"
        fi

        sed -i "s|versionYear = \".*\";|versionYear = \"$versionYear\";|" "$file"
        sed -i "s|versionMajor = \".*\";|versionMajor = \"$versionMajor\";|" "$file"
        sed -i "s|versionMinor = \".*\";|versionMinor = \"$versionMinor\";|" "$file"
        sed -i "s|versionRel = \".*\";|versionRel = \"$versionRel\";|" "$file"
        sed -i "s|url = \".*\";|url = \"$url\";|" "$file"
        sed -i "s|hash = \".*\";|hash = \"$hash\";|" "$file"
      '';
    };

  base = callPackage ./base.nix { };
  hpc = callPackage ./hpc.nix { };
}
