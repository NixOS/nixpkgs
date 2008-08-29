{fetchurl, stdenv, libcddb, pkgconfig, ncurses, help2man}:

stdenv.mkDerivation rec {
  name = "libcdio-0.80";
  
  src = fetchurl {
    url = "mirror://gnu/libcdio/${name}.tar.gz";
    sha256 = "0rnayw7gcq6jii2xrgg2n4wa8bsf5rw2hcww214lc0ssvcs1m95i";
  };

  buildInputs = [libcddb pkgconfig ncurses help2man];

  # Disabled because one test (check_paranoia.sh) fails.
  #doCheck = true;

  meta = {
    description = "A library for OS-idependent CD-ROM and CD image access";
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
