{ lib
, stdenv
, fetchFromGitHub
, runtimeShell
, cacert
, cmake
, cmakerc
, curl
, fmt
, git
, gzip
, meson
, ninja
, openssh
, python3
, unzip
, zip
, zstd
, extraRuntimeDeps ? []
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vcpkg-tool";
  version = "2024-06-10";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vcpkg-tool";
    rev = finalAttrs.version;
    hash = "sha256-TGRTzUd1FtErD+h/ksUsUm1Rhank9/yVy06JbAgEEw0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    cmakerc
    fmt
  ];

  patches = [
    ./change-lock-location.patch
  ];

  cmakeFlags = [
    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON"
    "-DVCPKG_DEPENDENCY_CMAKERC=ON"
  ];


  # vcpkg needs two directories to write to that is independent of installation directory.
  passAsFile = [ "vcpkgWrapper" ];
  vcpkgWrapper = let
    # These are the most common binaries used by vcpkg
    # Extra binaries can be added via overlay when needed
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
    ] ++ extraRuntimeDeps;
    setEnvvar = k: v: ''${k}=''${${k}-"${v}"}'';
  in ''
    #!${runtimeShell}

    NIX_VCPKG_WRITABLE_PATH=''${NIX_VCPKG_WRITABLE_PATH:-''${XDG_CACHE_HOME+"$XDG_CACHE_HOME/vcpkg"}}
    NIX_VCPKG_WRITABLE_PATH=''${NIX_VCPKG_WRITABLE_PATH:-''${HOME+"$HOME/.vcpkg/root"}}
    NIX_VCPKG_WRITABLE_PATH=''${NIX_VCPKG_WRITABLE_PATH:-''${TMP}}
    NIX_VCPKG_WRITABLE_PATH=''${NIX_VCPKG_WRITABLE_PATH:-'/tmp'}

    ${setEnvvar "NIX_VCPKG_DOWNLOADS_ROOT" "$NIX_VCPKG_WRITABLE_PATH/downloads"}
    ${setEnvvar "NIX_VCPKG_BUILDTREES_ROOT" "$NIX_VCPKG_WRITABLE_PATH/buildtrees"}
    ${setEnvvar "NIX_VCPKG_PACKAGES_ROOT" "$NIX_VCPKG_WRITABLE_PATH/packages"}
    ${setEnvvar "NIX_VCPKG_INSTALL_ROOT" "$NIX_VCPKG_WRITABLE_PATH/installed"}

    export PATH="${lib.makeBinPath runtimeDeps}''${PATH:+":$PATH"}"

    exec -a "$0" "${placeholder "out"}/bin/.vcpkg-wrapped" \
      --x-downloads-root="$NIX_VCPKG_DOWNLOADS_ROOT" \
      --x-buildtrees-root="$NIX_VCPKG_BUILDTREES_ROOT" \
      --x-packages-root="$NIX_VCPKG_PACKAGES_ROOT" \
      --x-install-root="$NIX_VCPKG_INSTALL_ROOT" \
      "$@"
  '';

  postFixup = ''
    mv "$out/bin/vcpkg" "$out/bin/.vcpkg-wrapped"
    install -Dm555 "$vcpkgWrapperPath" "$out/bin/vcpkg"
  '';

  meta = {
    description = "Components of microsoft/vcpkg's binary";
    mainProgram = "vcpkg";
    homepage = "https://github.com/microsoft/vcpkg-tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guekka gracicot ];
    platforms = lib.platforms.all;
  };
})
