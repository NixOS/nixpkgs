{ stdenv, fetchurl, pkgconfig, perl, python, zip, libffi, readline }:

stdenv.mkDerivation rec {
  version = "31.5.0";
  name = "spidermonkey-${version}";

  # the release notes point to some guys home directory, see
  # https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Releases/31
  # probably it would be more ideal to pull a particular tag/revision
  # from the mercurial repo
  src = fetchurl {
    url = "https://people.mozilla.org/~sstangl/mozjs-31.5.0.tar.bz2";
    sha256 = "1q8icql5hh1g3gzg5fp4rl9rfagyhm9gilfn3dgi7qn4i1mrfqsd";
  };

  buildInputs = [ pkgconfig perl python zip libffi readline ];

  postUnpack = "sourceRoot=\${sourceRoot}/js/src";

  preConfigure = ''
    export CXXFLAGS="-fpermissive"
    export LIBXUL_DIST=$out
  '';

  configureFlags = [
    "--enable-threadsafe"
    "--with-system-ffi"
    "--enable-readline"

    # enabling these because they're wanted by 0ad. They may or may
    # not be good defaults for other uses.
    "--enable-gcgenerational"
    "--enable-shared-js"

    # Due to a build-system bug, this means the exact opposite of what it says.
    # It is required by gcgenerational.
    "--disable-exact-rooting"
  ];

  # This addresses some build system bug. It's quite likely to be safe
  # to re-enable parallel builds if the source revision changes.
  enableParallelBuilding = false;

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

    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
