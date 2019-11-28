{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libxl";
  version = "3.8.7";

  src = fetchurl {
    url = "http://www.libxl.com/download/${pname}-lin-${version}.tar.gz";
    sha256 = "0mfi2mlsgqjw9ki3c5bsb6nr2aqym7s1priw70f69r12azzxfqw3";
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
