{
  lib,
  stdenv,
  fetchFromGitHub,
  runtimeShell,
  cacert,
  cmake,
  cmakerc,
  curl,
  fmt_11,
  git,
  gzip,
  meson,
  ninja,
  openssh,
  python3,
  unzip,
  zip,
  zstd,
  runCommand,
  writeText,
  extraRuntimeDeps ? [ ],
  doWrap ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vcpkg-tool";
  version = "2025-10-16";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vcpkg-tool";
    rev = finalAttrs.version;
    hash = "sha256-Qu7e2cb4fDAiJ4PXRzgdsvTMM8eo6dwRCNpd/w3vWLw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    cmakerc
    fmt_11
  ];

  patches = [
    ./change-lock-location.patch
    ./read-bundle-info-from-root.patch
  ];

  cmakeFlags = [
    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON"
    "-DVCPKG_DEPENDENCY_CMAKERC=ON"
  ];

  passAsFile = [ "vcpkgWrapper" ];
  vcpkgWrapper =
    let
      # These are the most common binaries used by vcpkg
      # Extra binaries can be added through override when needed
      runtimeDeps = [
        cacert
        cmake
        curl
        git
        gzip
        meson
        ninja
        openssh
        python3
        unzip
        zip
        zstd
      ]
      ++ extraRuntimeDeps;

      # Apart from adding the runtime dependencies to $PATH,
      # the wrapper will also override these arguments by default.
      # This is to ensure that the executable does not try to
      # write to the nix store. If the user tries to set any of the
      # arguments themself, the wrapper will detect that the
      # arguments are present, and prefer the user-provided value.
      #
      # It is also possible to override the cli arguments by
      # settings either of the nix-specific environment variables.
      argsWithDefault = [
        {
          arg = "--downloads-root";
          env = "NIX_VCPKG_DOWNLOADS_ROOT";
          default = "$NIX_VCPKG_WRITABLE_PATH/downloads";
        }
        {
          arg = "--x-buildtrees-root";
          env = "NIX_VCPKG_BUILDTREES_ROOT";
          default = "$NIX_VCPKG_WRITABLE_PATH/buildtrees";
        }
        {
          arg = "--x-packages-root";
          env = "NIX_VCPKG_PACKAGES_ROOT";
          default = "$NIX_VCPKG_WRITABLE_PATH/packages";
        }
        {
          arg = "--x-install-root";
          env = "NIX_VCPKG_INSTALL_ROOT";
          default = "$NIX_VCPKG_WRITABLE_PATH/installed";
        }
      ];
    in
    ''
      #!${runtimeShell}

      get_vcpkg_path() {
        if [[ -n $NIX_VCPKG_WRITABLE_PATH ]]; then
            echo "$NIX_VCPKG_WRITABLE_PATH"
        elif [[ -n $XDG_CACHE_HOME ]]; then
            echo "$XDG_CACHE_HOME/vcpkg"
        elif [[ -n $HOME ]]; then
            echo "$HOME/.vcpkg/root"
        elif [[ -n $TMP ]]; then
            echo "$TMP"
        else
            echo "/tmp"
        fi
      }

      NIX_VCPKG_WRITABLE_PATH=$(get_vcpkg_path)

      ${lib.concatMapStringsSep "\n" (
        { env, default, ... }: ''${env}=''${${env}-"${default}"}''
      ) argsWithDefault}

      export PATH="${lib.makeBinPath runtimeDeps}''${PATH:+":$PATH"}"

      ARGS=( "$@" )
      FINAL_NONMODIFIED_ARGS=()

      for (( i=0; i<''${#ARGS[@]}; i++ ));
      do
        case "''${ARGS[i]%%=*}" in
          ${
            let
              f =
                { arg, env, ... }:
                ''
                  '${arg}')
                    ${env}="''${ARGS[i]#*=}"
                    if [ "''$${env}" = '${arg}' ]; then
                      ${env}="''${ARGS[i+1]}"
                      ((i++))
                    fi
                    ;;
                '';
            in
            lib.concatMapStringsSep "\n" f argsWithDefault
          }
          *)
            FINAL_NONMODIFIED_ARGS+=(''${ARGS[i]})
            ;;
        esac
      done

      if [ "''${NIX_VCPKG_DEBUG_PRINT_ENVVARS-'false'}" = 'true' ]; then
        ${lib.concatMapStringsSep "\n" (
          { env, ... }: "  " + ''echo "${env} = ''$${env}"''
        ) argsWithDefault}
        echo ""
      fi

      exec -a "$0" "${placeholder "out"}/bin/.vcpkg-wrapped" \
      ${lib.concatMapStringsSep "\n" ({ arg, env, ... }: "  " + ''${arg}="''$${env}" \'') argsWithDefault}
        "''${FINAL_NONMODIFIED_ARGS[@]}"
    '';

  postFixup = lib.optionalString doWrap ''
    mv "$out/bin/vcpkg" "$out/bin/.vcpkg-wrapped"
    install -Dm555 "$vcpkgWrapperPath" "$out/bin/vcpkg"
  '';

  passthru.tests = lib.optionalAttrs doWrap {
    testWrapper = runCommand "vcpkg-tool-test-wrapper" { buildInputs = [ finalAttrs.finalPackage ]; } ''
      export NIX_VCPKG_DEBUG_PRINT_ENVVARS=true
      export VCPKG_ROOT=.
      vcpkg --x-packages-root="test" --x-install-root="test2" contact > "$out"

      cat "$out" | head -n 4 | diff - ${writeText "vcpkg-tool-test-wrapper-expected" ''
        NIX_VCPKG_DOWNLOADS_ROOT = /homeless-shelter/.vcpkg/root/downloads
        NIX_VCPKG_BUILDTREES_ROOT = /homeless-shelter/.vcpkg/root/buildtrees
        NIX_VCPKG_PACKAGES_ROOT = test
        NIX_VCPKG_INSTALL_ROOT = test2
      ''}
    '';
  };

  meta = {
    description = "Components of microsoft/vcpkg's binary";
    mainProgram = "vcpkg";
    homepage = "https://github.com/microsoft/vcpkg-tool";
    changelog = "https://github.com/microsoft/vcpkg-tool/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      guekka
      gracicot
      h7x4
    ];
    platforms = lib.platforms.all;
  };
})
