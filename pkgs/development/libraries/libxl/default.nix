{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libxl";
  version = "3.8.5";

  src = fetchurl {
    url = "http://www.libxl.com/download/${pname}-lin-${version}.tar.gz";
    sha256 = "15n8gxyznk1nm2kgp86hd36rnivjsby9ccl12lyabv6q3fab6fsx";
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
