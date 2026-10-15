{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  pkg-config,
  glib,
  libwnck,
  procps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsuspender";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "kernc";
    repo = "xsuspender";
    rev = finalAttrs.version;
    hash = "sha256-NXIqFtuiOhC5+1X3p8+nzZg8jvC2iu1YXXKulXRYyrA=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    glib
    libwnck
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.8 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  postInstall = ''
    wrapProgram $out/bin/xsuspender \
      --prefix PATH : "${lib.makeBinPath [ procps ]}"
  '';

  meta = {
    description = "Auto-suspend inactive X11 applications";
    mainProgram = "xsuspender";
    homepage = "https://kernc.github.io/xsuspender/";
    license = lib.licenses.wtfpl;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
