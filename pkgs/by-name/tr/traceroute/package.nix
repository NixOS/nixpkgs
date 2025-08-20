{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "traceroute";
  version = "2.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/traceroute/${pname}-${version}.tar.gz";
    sha256 = "sha256-nM75zbnXqY/3+/k/eevQ5IiBZktSXEsjKg/Ox9y5214=";
  };

  makeFlags = [
    "prefix=$(out)"
    "LDFLAGS=-lm"
    "env=yes"
  ];

  preConfigure = ''
    sed -i 's@LIBS := \(.*\) -lm \(.*\)@LIBS := \1 \2@' Make.rules
  '';

  meta = with lib; {
    description = "Tracks the route taken by packets over an IP network";
    homepage = "https://traceroute.sourceforge.net/";
    changelog = "https://sourceforge.net/projects/traceroute/files/traceroute/traceroute-${version}/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
    mainProgram = "traceroute";
  };
}
