{ stdenv, fetchurl, fetchpatch, autoconf213, pkgconfig, perl, python2, zip, which, readline, icu, zlib, nspr }:

let
  version = "60.2.0";
in stdenv.mkDerivation rec {
  name = "spidermonkey-${version}";

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha256 = "05vpwyxsy7q6w6ff1r51wd69hzcl36rfkqr28gklq8s8as5xqnvr";
  };

  buildInputs = [ readline icu zlib nspr ];
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

  # We need the flags specified here for gjs:
  # https://gitlab.gnome.org/GNOME/gnome-sdk-images/blob/bc8829439a4f1019d0c56a293ddd84e936fdf9f9/org.gnome.Sdk.json.in#L744
  configureFlags = [
    "--with-system-zlib"
    "--with-system-icu"
    "--with-intl-api"
    "--enable-readline"
    "--enable-shared-js"
    "--enable-posix-nspr-emulation"
    "--disable-jemalloc"
    "--enable-release"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = https://developer.mozilla.org/en/SpiderMonkey;
    license = licenses.gpl2; # TODO: MPL/GPL/LGPL tri-license.
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}
