{ stdenv, fetchurl, unzip }:

let
  version = "2.6.2";
  SHLIB_EXT = if stdenv.isDarwin then "dylib" else "so";
in stdenv.mkDerivation {
  name = "tinyxml-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/tinyxml/tinyxml/${version}/tinyxml_2_6_2.zip";
    sha256 = "04nmw6im2d1xp12yir8va93xns5iz816pwi25n9cql3g3i8bjsxc";
  };

  patches = [
    # add pkgconfig file
    ./2.6.2-add-pkgconfig.patch

    # http://sourceforge.net/tracker/index.php?func=detail&aid=3031828&group_id=13559&atid=313559
    ./2.6.2-entity.patch

    # Use CC, CXX, and LD from environment
    ./2.6.2-cxx.patch
  ];
  preConfigure = "export LD=${if stdenv.isDarwin then "clang++" else "g++"}";

  NIX_CFLAGS_COMPILE =
    stdenv.lib.optional stdenv.isDarwin "-mmacosx-version-min=10.9";

  buildInputs = [ unzip ];
  buildPhase = ''
    # use STL (xbmc requires it)
    sed '1i#define TIXML_USE_STL 1' -i tinyxml.h
    sed '1i#define TIXML_USE_STL 1' -i xmltest.cpp

    # build xmltest
    make

    # build the lib as a shared library
    ''${CXX} -Wall -O2 -shared -fpic tinyxml.cpp \
    tinyxmlerror.cpp tinyxmlparser.cpp      \
    tinystr.cpp -o libtinyxml.${SHLIB_EXT}
  '';

  doCheck = true;
  checkPhase = ''
    ./xmltest
    result=$?
    if [[ $result != 0 ]] ; then
      exit $result
    fi
  '';

  installPhase = ''
    mkdir -pv $out/include/
    mkdir -pv $out/lib/pkgconfig/
    mkdir -pv $out/share/doc/tinyxml/

    cp -v libtinyxml.${SHLIB_EXT} $out/lib/
    cp -v *.h $out/include/

    substituteInPlace tinyxml.pc --replace "@out@" "$out"
    substituteInPlace tinyxml.pc --replace "@version@" "${version}"
    cp -v tinyxml.pc $out/lib/pkgconfig/

    cp -v docs/* $out/share/doc/tinyxml/
  '';

  meta = {
    description = "Simple, small, C++ XML parser that can be easily integrating into other programs";
    homepage = "http://www.grinninglizard.com/tinyxml/index.html";
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
  };
}
