{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  unzip,
}:

let
  version = "2.6.2";
  SHLIB_EXT = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation {
  pname = "tinyxml";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/project/tinyxml/tinyxml/${version}/tinyxml_2_6_2.zip";
    sha256 = "04nmw6im2d1xp12yir8va93xns5iz816pwi25n9cql3g3i8bjsxc";
  };

  patches = [
    # add pkg-config file
    ./2.6.2-add-pkgconfig.patch

    # https://sourceforge.net/tracker/index.php?func=detail&aid=3031828&group_id=13559&atid=313559
    ./2.6.2-entity.patch

    # Use CC, CXX, and LD from environment
    ./2.6.2-cxx.patch

    (fetchpatch {
      name = "CVE-2023-34194.patch";
      url = "https://salsa.debian.org/debian/tinyxml/-/raw/2366e1f23d059d4c20c43c54176b6bd78d6a83fc/debian/patches/CVE-2023-34194.patch";
      hash = "sha256-ow4LmLQV24SAU6M1J8PXpW5c95+el3t8weM9JK5xJfg=";
    })
    (fetchpatch {
      name = "CVE-2021-42260.patch";
      url = "https://salsa.debian.org/debian/tinyxml/-/raw/dc332a9f4e05496c8342b778c14b256083beb1ee/debian/patches/CVE-2021-42260.patch";
      hash = "sha256-pIM0uOnUQOW93w/PEPuW3yKq1mdvNT/ClCYVc2hLoY8=";
    })
  ];

  preConfigure = "export LD=${stdenv.cc.targetPrefix}c++";

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-mmacosx-version-min=10.9";

  nativeBuildInputs = [ unzip ];
  buildPhase = ''
    # use STL (xbmc requires it)
    sed '1i#define TIXML_USE_STL 1' -i tinyxml.h
    sed '1i#define TIXML_USE_STL 1' -i xmltest.cpp

    # build xmltest
    make

    # build the lib as a shared library
    ''${CXX} -Wall -O2 -shared -fpic tinyxml.cpp \
    tinyxmlerror.cpp tinyxmlparser.cpp      \
    tinystr.cpp -o libtinyxml${SHLIB_EXT}
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

    cp -v libtinyxml${SHLIB_EXT} $out/lib/
    cp -v *.h $out/include/

    substituteInPlace tinyxml.pc --replace "@out@" "$out"
    substituteInPlace tinyxml.pc --replace "@version@" "${version}"
    cp -v tinyxml.pc $out/lib/pkgconfig/

    cp -v docs/* $out/share/doc/tinyxml/
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id $out/lib/libtinyxml.dylib $out/lib/libtinyxml.dylib
  '';

  meta = {
    description = "Simple, small, C++ XML parser that can be easily integrating into other programs";
    homepage = "http://www.grinninglizard.com/tinyxml/index.html";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
}
