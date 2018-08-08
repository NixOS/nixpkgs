{ stdenv, fetchurl, fetchpatch, autoconf213, pkgconfig, perl, python2, zip, which, readline, icu, zlib, nspr }:

let
  version = "52.9.0";
in stdenv.mkDerivation rec {
  name = "spidermonkey-${version}";

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha256 = "1mlx34fgh1kaqamrkl5isf0npch3mm6s4lz3jsjb7hakiijhj7f0";
  };

  buildInputs = [ readline icu zlib nspr ];
  nativeBuildInputs = [ autoconf213 pkgconfig perl which python2 zip ];

  # Apparently this package fails to build correctly with modern compilers, which at least
  # on ARMv6 causes polkit testsuite to break with an assertion failure in spidermonkey.
  # These flags were stolen from:
  # https://git.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/js52
  NIX_CFLAGS_COMPILE = "-fno-delete-null-pointer-checks -fno-strict-aliasing -fno-tree-vrp";

  patches = [
    # needed to build gnome3.gjs
    (fetchpatch {
      name = "mozjs52-disable-mozglue.patch";
      url = https://git.archlinux.org/svntogit/packages.git/plain/trunk/mozjs52-disable-mozglue.patch?h=packages/js52&id=4279d2e18d9a44f6375f584911f63d13de7704be;
      sha256 = "18wkss0agdyff107p5lfflk72qiz350xqw2yqc353alkx4fsfpz0";
    })
  ];

  preConfigure = ''
    export CXXFLAGS="-fpermissive"
    export LIBXUL_DIST=$out
    export PYTHON="${python2.interpreter}"

    cd js/src

    autoconf
  '';

  configureFlags = [
    "--with-system-nspr"
    "--with-system-zlib"
    "--with-system-icu"
    "--with-intl-api"
    "--enable-readline"
    "--enable-shared-js"
  ] ++ stdenv.lib.optional stdenv.hostPlatform.isMusl "--disable-jemalloc";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = https://developer.mozilla.org/en/SpiderMonkey;
    license = licenses.gpl2; # TODO: MPL/GPL/LGPL tri-license.
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}
