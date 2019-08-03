{ stdenv, fetchurl, fetchpatch, autoconf213, pkgconfig, perl, python2, zip
, which, readline, zlib, icu }:

let
  version = "60.4.0";
in stdenv.mkDerivation rec {
  name = "spidermonkey-${version}";

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha256 = "11gzxd82grc3kg1ha4yni6ag6b97n46qycvv6x15s91ziia5hli0";
  };

  buildInputs = [ readline zlib icu ];
  nativeBuildInputs = [ autoconf213 pkgconfig perl which python2 zip ];

  patches = [
    (fetchpatch {
      url = https://bug1415202.bmoattachments.org/attachment.cgi?id=8926363;
      sha256 = "082ryrvqa3lvs67v3sq9kf2jshf4qp1fpi195wffc40jdrl8fnin";
    })
  ];

  preConfigure = ''
    export CXXFLAGS="-fpermissive"
    export LIBXUL_DIST=$out
    export PYTHON="${python2.interpreter}"

    # We can't build in js/src/, so create a build dir
    mkdir obj
    cd obj/
    configureScript=../js/src/configure
  '';

  configureFlags = [
    "--with-system-zlib"
    "--with-system-icu"
    "--with-intl-api"
    "--enable-readline"
    "--enable-shared-js"
    "--enable-posix-nspr-emulation"
    "--disable-jemalloc"
    # Fedora and Arch disable optimize, but it doesn't seme to be necessary
    # It turns on -O3 which some gcc version had a problem with:
    # https://src.fedoraproject.org/rpms/mozjs38/c/761399aba092bcb1299bb4fccfd60f370ab4216e
    "--enable-optimize"
    "--enable-release"
  ];

  # Remove unnecessary static lib
  preFixup = ''
    rm $out/lib/libjs_static.ajs
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = https://developer.mozilla.org/en/SpiderMonkey;
    license = licenses.gpl2; # TODO: MPL/GPL/LGPL tri-license.
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}
