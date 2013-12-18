{ fetchurl, stdenv, libcddb, pkgconfig, ncurses, help2man }:

stdenv.mkDerivation rec {
  name = "libcdio-0.90";
  
  src = fetchurl {
    url = "mirror://gnu/libcdio/${name}.tar.gz";
    sha256 = "0kpp6gr5sjr30pb9klncc37fhkw0wi6r41d2fmvmw17cbj176zmg";
  };

  buildInputs = [ libcddb pkgconfig ncurses help2man ];

  # Disabled because one test (check_paranoia.sh) fails.
  #doCheck = true;

  meta = {
    description = "A library for OS-independent CD-ROM and CD image access";
    longDescription = ''
      GNU libcdio is a library for OS-idependent CD-ROM and
      CD image access.  It includes a library for working with
      ISO-9660 filesystems (libiso9660), as well as utility
      programs such as an audio CD player and an extractor.
    '';
    license = "GPLv2+";
    homepage = http://www.gnu.org/software/libcdio/;
  };
}
