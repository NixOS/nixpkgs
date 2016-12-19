{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libsass-${version}";
  version = "3.3.2";

  src = fetchurl {
    url = "https://github.com/sass/libsass/archive/${version}.tar.gz";
    sha256 = "affb7efaa7e152e576cc1d510c662ebe067b0b9e9228ad2937dcafdd4431b573";
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
