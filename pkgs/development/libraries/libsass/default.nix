{ stdenv, fetchurl, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libsass-${version}";
  version = "3.5.4";

  src = fetchurl {
    url = "https://github.com/sass/libsass/archive/${version}.tar.gz";
    sha256 = "0w47hvzmbdpbjx8j83wn8dwcvglpab8abkszf9xfzrpqvb6wnqaz";
  };

  patches = [
    # CVE-2018-11693, is in master but no release yet
    (fetchpatch {
      url = "https://github.com/sass/libsass/commit/af0e12cdf09d43dbd1fc11e3f64b244277cc1a1e.patch";
      sha256 = "1y8yvjvvz91lcr1kpq2pw8729xhdgp15mbldcw392pfzdlliwdyl";
    })
  ];

  preConfigure = ''
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
