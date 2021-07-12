{ lib
, stdenv
, fetchurl
, pkg-config
, freetype
, cmake
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  version = "1.3.14";
  pname = "graphite2";

  src = fetchurl {
    url = "https://github.com/silnrsi/graphite/releases/download/"
      + "${version}/graphite2-${version}.tgz";
    sha256 = "1790ajyhk0ax8xxamnrk176gc9gvhadzy78qia4rd8jzm89ir7gr";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ freetype ];

  patches = lib.optionals stdenv.isDarwin [ ./macosx.patch ];

  cmakeFlags = lib.optionals static [
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  # Remove a test that fails to statically link (undefined reference to png and
  # freetype symbols)
  postConfigure = lib.optionals static ''
    sed -e '/freetype freetype.c/d' -i ../tests/examples/CMakeLists.txt
  '';

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/src/
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD/src/
  '';

  doCheck = true;

  meta = with lib; {
    description = "An advanced font engine";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
