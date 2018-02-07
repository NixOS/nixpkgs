{ stdenv, fetchurl, autoconf213, pkgconfig, perl, python2, zip, which, readline, icu, zlib, nspr }:

stdenv.mkDerivation rec {
  version = "52.2.1gnome1";
  name = "spidermonkey-${version}";

  # the release notes point to some guys home directory, see
  # https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Releases/38
  # probably it would be more ideal to pull a particular tag/revision
  # from the mercurial repo
  src = fetchurl {
    url = "mirror://gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-${version}.tar.gz";
    sha256 = "1bxhz724s1ch1c0kdlzlg9ylhg1mk8kbhdgfkax53fyvn51pjs9i";
  };

  buildInputs = [ readline icu zlib nspr ];
  nativeBuildInputs = [ autoconf213 pkgconfig perl which python2 zip ];

  postUnpack = "sourceRoot=\${sourceRoot}/js/src";

  preConfigure = ''
    export CXXFLAGS="-fpermissive"
    export LIBXUL_DIST=$out
    export PYTHON="${python2.interpreter}"
  '';

  configureFlags = [
    "--enable-threadsafe"
    "--with-system-nspr"
    "--with-system-zlib"
    "--with-system-icu"
    "--with-intl-api"
    "--enable-readline"

    # enabling these because they're wanted by 0ad. They may or may
    # not be good defaults for other uses.
    "--enable-gcgenerational"
    "--enable-shared-js"
  ];

  # This addresses some build system bug. It's quite likely to be safe
  # to re-enable parallel builds if the source revision changes.
  enableParallelBuilding = true;

  postFixup = ''
    # The headers are symlinks to a directory that doesn't get put
    # into $out, so they end up broken. Fix that by just resolving the
    # symlinks.
    for i in $(find $out -type l); do
      cp --remove-destination "$(readlink "$i")" "$i";
    done
  '';

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = https://developer.mozilla.org/en/SpiderMonkey;
    # TODO: MPL/GPL/LGPL tri-license.

    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}
