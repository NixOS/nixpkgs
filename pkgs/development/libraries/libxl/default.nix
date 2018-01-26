{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libxl";
  version = "3.8.1";

  src = fetchurl {
    url = "http://www.libxl.com/download/${name}-lin-${version}.tar.gz";
    sha256 = "1zdbahhyhr70s8hygwp43j9z4zmglyrr782hkcm1078yvkr2f2fm";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir $out
    cp -rva include_c include_cpp license.txt $out/
    cp -rva lib64 $out/lib
  '';

  meta = with stdenv.lib; {
    description = "A lbrary for parsing excel files";
    license     = licenses.unfree;
    platforms   = platforms.linux;
    maintainers = with maintainers; [  ];
  };
}
