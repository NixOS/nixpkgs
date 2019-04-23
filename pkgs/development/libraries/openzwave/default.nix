{ stdenv, fetchFromGitHub
, doxygen, fontconfig, graphviz-nox, libxml2, pkgconfig, which
, systemd }:

let
  version = "2018-11-13";

in stdenv.mkDerivation rec {
  name = "openzwave-${version}";

  # Use fork by Home Assistant because this package is mainly used for python.pkgs.homeassistant-pyozw.
  # See https://github.com/OpenZWave/open-zwave/compare/master...home-assistant:hass for the difference.
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "open-zwave";
    rev = "0679daef6aa5a39e2441a68f7b45cfe022c4d961";
    sha256 = "1d13maj93i6h792cbvqpx43ffss44dxmvbwj2777vzvvjib8m4n8";
  };

  nativeBuildInputs = [ doxygen fontconfig graphviz-nox libxml2 pkgconfig which ];

  buildInputs = [ systemd ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    DESTDIR=$out PREFIX= pkgconfigdir=lib/pkgconfig make install $installFlags

    runHook postInstall
  '';

  FONTCONFIG_FILE="${fontconfig.out}/etc/fonts/fonts.conf";
  FONTCONFIG_PATH="${fontconfig.out}/etc/fonts/";

  postPatch = ''
    substituteInPlace cpp/src/Options.cpp \
      --replace /etc/openzwave $out/etc/openzwave
  '';

  fixupPhase = ''
    substituteInPlace $out/lib/pkgconfig/libopenzwave.pc \
      --replace prefix= prefix=$out \
      --replace dir=    dir=$out

    substituteInPlace $out/bin/ozw_config \
      --replace pcfile=${pkgconfig} pcfile=$out
  '';

  meta = with stdenv.lib; {
    description = "C++ library to control Z-Wave Networks via a USB Z-Wave Controller";
    homepage = http://www.openzwave.net/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
