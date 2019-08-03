{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libxl";
  version = "3.8.4";

  src = fetchurl {
    url = "http://www.libxl.com/download/${pname}-lin-${version}.tar.gz";
    sha256 = "0jnvc9ilir3lvs81l6ldnyf6jbfsy7bcs5pkc75qfnvz01y7p6as";
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
