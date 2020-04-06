{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libxl";
  version = "3.8.8";

  src = fetchurl {
    url = "https://www.libxl.com/download/${pname}-lin-${version}.tar.gz";
    sha256 = "08jarfcl8l5mrmkx6bcifi3ghkaja9isz77zgggl84yl66js5pc3";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -rva include_c include_cpp license.txt $out/
    cp -rva lib64 $out/lib
  '';

  meta = with stdenv.lib; {
    description = "A library for parsing Excel files";
    homepage    = "https://www.libxl.com/";
    license     = licenses.unfree;
    platforms   = platforms.linux;
    maintainers = with maintainers; [  ];
  };
}
