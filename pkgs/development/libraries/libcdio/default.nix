{fetchurl, stdenv, libcddb, pkgconfig, ncurses}:

stdenv.mkDerivation rec {
  name = "libcdio-0.79";
  src = fetchurl {
    url = "mirror://gnu/libcdio/${name}.tar.gz";
    sha256 = "1xfizvs0yvgs9ddazalsmccd6whqi5fy4dlm3dhcqj72wvpf7w0v";
  };

  buildInputs = [libcddb pkgconfig ncurses];

  doCheck = true;

  meta = {
    description = "GNU libcdio is a library for OS-idependent CD-ROM and CD image access";
    license = "GPLv2+";
    homepage = http://www.gnu.org/software/libcdio/;
  };
}
