{ stdenv, texinfo, flex, bison, fetchFromGitHub, crossLibcStdenv, buildPackages, espressifXtensaOverlays }:

crossLibcStdenv.mkDerivation {
  pname = "newlib-esp32";
  version = "unstable-2020-09-02";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "newlib-esp32";
    rev = "esp-2020r3";
    sha256 = "1azk8wdx62xpf6jpbxnk21adryyf9airs1xrr0iyhnfm8lhbxir0";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  postPatch = ''
    cp -RT ${espressifXtensaOverlays stdenv.targetPlatform}/newlib .
  '';

  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc
  '';

  configurePlatforms = [ "build" "target" ];
  configureFlags = [
    "--host=${stdenv.buildPlatform.config}"

    "--disable-newlib-supplied-syscalls"
    "--disable-nls"
    "--enable-newlib-io-long-long"
    "--enable-newlib-register-fini"
    "--enable-newlib-retargetable-locking"

    "--disable-newlib-io-c99-formats"
    "--enable-target-optspace"
    "--enable-newlib-long-time_t"
  ];

  dontDisableStatic = true;

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };
}
