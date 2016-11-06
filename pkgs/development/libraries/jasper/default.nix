{ stdenv, fetchurl, fetchpatch, unzip, libjpeg, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "jasper-1.900.21";

  src = fetchurl {
    url = "http://www.ece.uvic.ca/~mdadams/jasper/software/${name}.tar.gz";
    sha256 = "1cypmlzq5vmbacsn8n3ls9p7g64scv3fzx88qf8c270dz10s5j79";
  };

  # newer reconf to recognize a multiout flag
  nativeBuildInputs = [ unzip autoreconfHook ];
  propagatedBuildInputs = [ libjpeg ];

  configureFlags = "--enable-shared";

  outputs = [ "bin" "dev" "out" "man" ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://www.ece.uvic.ca/~frodo/jasper/;
    description = "JPEG2000 Library";
    platforms = stdenv.lib.platforms.unix;
  };
}
