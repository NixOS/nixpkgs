{
  stdenv,
  lib,
  crystal,
  pcre2,
  shards,
  git,
  pkg-config,
  which,
  linkFarm,
  fetchgit,
  fetchFromGitHub,
  installShellFiles,
  removeReferencesTo,
}:

{
  # Some projects do not include a lock file, so you can pass one
  lockFile ? null,
  # Generate shards.nix with `nix-shell -p crystal2nix --run crystal2nix` in the projects root
  shardsFile ? null,
  # We support different builders. To make things more straight forward, make it
  # user selectable instead of trying to autodetect
  format ? "make",
  installManPages ? true,
  # Specify binaries to build in the form { foo.src = "src/foo.cr"; }
  # The default `crystal build` options can be overridden with { foo.options = [ "--optionname" ]; }
  crystalBinaries ? { },
  enableParallelBuilding ? true,
  # Copy all shards dependencies instead of symlinking and add write permissions
  # to make environment more local-like
  copyShardDeps ? false,
  ...
}@args:

assert (
  builtins.elem format [
    "make"
    "crystal"
    "shards"
  ]
);
let
  mkDerivationArgs = removeAttrs args [
    "format"
    "installManPages"
    "lockFile"
    "shardsFile"
    "crystalBinaries"
  ];

  crystalLib = linkFarm "crystal-lib" (
    lib.mapAttrsToList (name: value: {
      inherit name;
      path = if (builtins.hasAttr "url" value) then fetchgit value else fetchFromGitHub value;
    }) (import shardsFile)
  );

  # We no longer use --no-debug in accordance with upstream's recommendation
  defaultOptions = [
    "--release"
    "--progress"
    "--verbose"
  ];

  buildDirectly = shardsFile == null || crystalBinaries != { };

  mkCrystalBuildArgs =
    bin: attrs:
    lib.concatStringsSep " " (
      [
        "crystal"
        "build"
      ]
      ++ lib.optionals enableParallelBuilding [
        "--threads"
        "$NIX_BUILD_CORES"
      ]
      ++ [
        "-o"
        bin
        (attrs.src or (throw "No source file for crystal binary ${bin} provided"))
        (lib.concatStringsSep " " (attrs.options or defaultOptions))
      ]
    );

in
stdenv.mkDerivation (
  mkDerivationArgs
  // {

    configurePhase =
      args.configurePhase or (lib.concatStringsSep "\n" (
        [
          "runHook preConfigure"
        ]
        ++ lib.optional (lockFile != null) "cp ${lockFile} ./shard.lock"
        ++ lib.optionals (shardsFile != null) [
          "test -e lib || mkdir lib"
          (
            if copyShardDeps then
              "for d in ${crystalLib}/*; do cp -r $d/ lib/; done; chmod -R +w lib/"
            else
              "for d in ${crystalLib}/*; do ln -s $d lib/; done"
          )
          "cp shard.lock lib/.shards.info"
        ]
        ++ [ "runHook postConfigure" ]
      ));

    CRFLAGS = lib.concatStringsSep " " defaultOptions;

    PREFIX = placeholder "out";

    inherit enableParallelBuilding;
    strictDeps = true;
    buildInputs =
      args.buildInputs or [ ]
      ++ [ crystal ]
      ++ lib.optional (lib.versionAtLeast crystal.version "1.8") pcre2;

    nativeBuildInputs =
      args.nativeBuildInputs or [ ]
      ++ [
        crystal
        git
        installShellFiles
        removeReferencesTo
        pkg-config
        which
      ]
      ++ lib.optional (format != "crystal") shards;

    buildPhase =
      args.buildPhase or (lib.concatStringsSep "\n" (
        [
          "runHook preBuild"
        ]
        ++ lib.optional (format == "make") "make \${buildTargets:-build} $makeFlags"
        ++ lib.optionals (format == "crystal") (lib.mapAttrsToList mkCrystalBuildArgs crystalBinaries)
        ++
          lib.optional (format == "shards")
            "shards build --local --production ${lib.concatStringsSep " " (args.options or defaultOptions)}"
        ++ [ "runHook postBuild" ]
      ));

    installPhase =
      args.installPhase or (lib.concatStringsSep "\n" (
        [
          "runHook preInstall"
        ]
        ++ lib.optional (format == "make") "make \${installTargets:-install} $installFlags"
        ++ lib.optionals (format == "crystal") (
          map (bin: ''
            install -Dm555 ${
              lib.escapeShellArgs [
                bin
                "${placeholder "out"}/bin/${bin}"
              ]
            }
          '') (lib.attrNames crystalBinaries)
        )
        ++ lib.optional (format == "shards") "install -Dm555 bin/* -t $out/bin"
        ++ [
          ''
            for f in README* *.md LICENSE; do
              test -f $f && install -Dm444 $f -t $out/share/doc/${args.pname}
            done
          ''
        ]
        ++ (lib.optional installManPages ''
          if [ -d man ]; then
            installManPage man/*.?
          fi
        '')
        ++ [
          "remove-references-to -t ${lib.getLib crystal} $out/bin/*"
          "runHook postInstall"
        ]
      ));

    doCheck = args.doCheck or true;

    checkPhase =
      args.checkPhase or (lib.concatStringsSep "\n" (
        [
          "runHook preCheck"
        ]
        ++ lib.optional (format == "make") "make \${checkTarget:-test} $checkFlags"
        ++ lib.optional (format != "make") "crystal \${checkTarget:-spec} $checkFlags"
        ++ [ "runHook postCheck" ]
      ));

    doInstallCheck = args.doInstallCheck or true;

    installCheckPhase =
      args.installCheckPhase or ''
        for f in $out/bin/*; do
          if [ $f == $out/bin/*.dwarf ]; then
            continue
          fi
          $f --help > /dev/null
        done
      '';

    meta = args.meta or { } // {
      platforms = args.meta.platforms or crystal.meta.platforms;
    };
  }
)
