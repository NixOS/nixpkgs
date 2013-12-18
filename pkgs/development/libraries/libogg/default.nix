{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  name = "libogg-1.3.1";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${name}.tar.xz";
    sha256 = "1ynwij1qdibwb2nvcl3ixri0c6pvq1higl96hf87iyqsv1wasnrs";
  };

  nativeBuildInputs = [ xz ];

  meta = {
    homepage = http://xiph.org/ogg/;
  };
}
