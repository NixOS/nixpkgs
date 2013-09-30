{ stdenv, fetchurl, pkgconfig, autoconf213, nspr, perl, python, readline, zip }:

stdenv.mkDerivation rec {
  version = "185-1.0.0";
  name = "spidermonkey-${version}";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/js/js${version}.tar.gz";
    sha256 = "5d12f7e1f5b4a99436685d97b9b7b75f094d33580227aa998c406bbae6f2a687";
  };

  propagatedBuildInputs = [ nspr ];

  buildInputs = [ pkgconfig autoconf213 perl python readline zip ];

  postUnpack = "sourceRoot=\${sourceRoot}/js/src";

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${nspr}/include/nspr"
    export LIBXUL_DIST=$out
    autoconf
  '';

  meta = with stdenv.lib; {
      description = "Mozilla's JavaScript engine written in C/C++";
      homepage = https://developer.mozilla.org/en/SpiderMonkey;
      # TODO: MPL/GPL/LGPL tri-license.
      maintainers = [ maintainers.goibhniu ];
  };

}
