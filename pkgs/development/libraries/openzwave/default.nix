{ lib, stdenv, fetchFromGitHub, fetchpatch
, doxygen, fontconfig, graphviz-nox, libxml2, pkg-config, which
, systemd }:

stdenv.mkDerivation rec {
  pname = "openzwave";
  version = "unstable-2022-08-08";

  src = fetchFromGitHub {
    owner = "OpenZWave";
    repo = "open-zwave";
    rev = "5e7da0e9f430426bac1c6add5503621723ed41ea";
    sha256 = "1bf04k70qd0rq9yvgq60ji2g30c5zf2x0qr78nnhzkjpz7ca53qm";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ doxygen fontconfig graphviz-nox libxml2 pkg-config which ];

  buildInputs = [ systemd ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  FONTCONFIG_FILE="${fontconfig.out}/etc/fonts/fonts.conf";
  FONTCONFIG_PATH="${fontconfig.out}/etc/fonts/";

  postPatch = ''
    substituteInPlace cpp/src/Options.cpp \
      --replace /etc/openzwave $out/etc/openzwave
    substituteInPlace cpp/build/Makefile  \
      --replace "-Werror" "-Werror -Wno-format"
  '';

  meta = with lib; {
    description = "C++ library to control Z-Wave Networks via a USB Z-Wave Controller";
    homepage = "http://www.openzwave.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
