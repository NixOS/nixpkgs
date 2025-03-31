{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  curl,
  gpgme,
  libsolv,
  libxml2,
  pkg-config,
  python3,
  rpm,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tdnf";
  version = "3.5.9";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = "tdnf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-p9g+b7Fqq8V6QSaikEQMMHWqBf4UtRA9a/VtH+s5JUM=";
  };

  patches = [
    # Support for rpm >= 4.19
    (fetchpatch2 {
      url = "https://patch-diff.githubusercontent.com/raw/vmware/tdnf/pull/410.patch";
      hash = "sha256-p/ix5O1J/lj2fw7qJokT+wPN4ROoulnVqByfxgFvuEo=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    curl.dev
    gpgme.dev
    libsolv
    libxml2.dev
    sqlite.dev
  ];

  propagatedBuildInputs = [
    rpm
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DCMAKE_INSTALL_FULL_SYSCONDIR=$out/etc"
    "-DCMAKE_INSTALL_SYSCONFDIR=$out/etc"
    "-DSYSTEMD_DIR=$out/lib/systemd/system"
  ];

  # error: format not a string literal and no format arguments [-Werror=format-security]
  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'SYSCONFDIR /etc' 'SYSCONFDIR $out/etc' \
      --replace-fail '/etc/motdgen.d' '$out/etc/motdgen.d'
    substituteInPlace client/tdnf.pc.in \
      --replace-fail 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@'
    substituteInPlace tools/cli/lib/tdnf-cli-libs.pc.in \
      --replace-fail 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@'
  '';

  # remove binaries used for testing from the final output
  postInstall = "rm $out/bin/*test";

  meta = {
    description = "Tiny Dandified Yum";
    homepage = "https://github.com/vmware/tdnf";
    changelog = "https://github.com/vmware/tdnf/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl2
      lgpl21
    ];
    maintainers = [ lib.maintainers.malt3 ];
    mainProgram = "tdnf";
    # rpm only supports linux
    platforms = lib.platforms.linux;
  };
})
