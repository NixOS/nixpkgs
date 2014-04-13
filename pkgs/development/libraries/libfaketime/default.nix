{stdenv, fetchurl }:

stdenv.mkDerivation rec
{
  version = "0.9.5";
  name = "libfaketime-${version}";

#  src = fetchgit {
#    url = "https://github.com/wolfcw/libfaketime.git";
#    rev = "4c23ee273006e72a26dcbba62317ab05645e892d";
#    sha256 = "efa231e0091e8c7785385149dc97b2d8dc24aba65f4b0974b8ed7f62b7596ad3";
#  };

#  Need http-only storing facility, like tarballs.nixos.org
#  src = fetchurl {
#    url = http://github.com/wolfcw/libfaketime/archive/v0.9.5.tar.gz;
#    sha256 = "efa231e0091e8c7785385149dc97b2d8dc24aba65f4b0974b8ed7f62b7596ad3";
#  };

  src = ./libfaketime-v0.9.5.tar.gz;

#  buildInputs = [ ];

  preBuild = ''
    makeFlags="PREFIX=$out LIBDIRNAME=/lib"
    '';

  patches = [
    ./avoid-spurious-lrt.patch
    ./no-date-in-gzip-man-page.patch
  ];

  meta =
  {
    homepage = "https://github.com/wolfcw/libfaketime";
    description = "libfaketime modifies the system time for a single application";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
