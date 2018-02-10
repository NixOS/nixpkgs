{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libsass-${version}";
  version = "3.4.8";

  src = fetchurl {
    url = "https://github.com/sass/libsass/archive/${version}.tar.gz";
    sha256 = "0gq0mg42sq2nxiv25fh37frlr0iyqamh7shv83qixnqklqpkfi13";
  };

  patchPhase = ''
    export LIBSASS_VERSION=${version}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "A C/C++ implementation of a Sass compiler";
    homepage = https://github.com/sass/libsass;
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel offline ];
    platforms = platforms.unix;
  };
}
