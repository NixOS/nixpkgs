{ stdenv, fetchFromGitHub
, doxygen, fontconfig, graphviz-nox, libxml2, pkgconfig, which
, systemd }:

let
  version = "2018-04-04";

in stdenv.mkDerivation rec {
  name = "openzwave-${version}";

  src = fetchFromGitHub {
    owner = "OpenZWave";
    repo = "open-zwave";
    rev = "ab5fe966fee882bb9e8d78a91db892a60a1863d9";
    sha256 = "0yby8ygzjn5zp5vhysxaadbzysqanwd2zakz379299qs454pr2h9";
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
