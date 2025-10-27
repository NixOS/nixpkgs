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

stdenv.mkDerivation rec {
  pname = "xsuspender";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "kernc";
    repo = "xsuspender";
    rev = version;
    sha256 = "1c6ab1s9bbkjbmcfv2mny273r66dlz7sgxsmzfwi0fm2vcb2lwim";
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

  meta = with lib; {
    description = "Auto-suspend inactive X11 applications";
    mainProgram = "xsuspender";
    homepage = "https://kernc.github.io/xsuspender/";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
