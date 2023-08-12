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

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ freetype ];

  patches = lib.optionals stdenv.isDarwin [ ./macosx.patch ];
  postPatch = ''
    # disable broken 'nametabletest' test, fails on gcc-13:
    #   https://github.com/silnrsi/graphite/pull/74
    substituteInPlace tests/CMakeLists.txt \
      --replace 'add_subdirectory(nametabletest)' '#add_subdirectory(nametabletest)'
  '';

  cmakeFlags = lib.optionals static [
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  # Remove a test that fails to statically link (undefined reference to png and
  # freetype symbols)
  postConfigure = lib.optionalString static ''
    sed -e '/freetype freetype.c/d' -i ../tests/examples/CMakeLists.txt
  '';

  doCheck = true;

  meta = with lib; {
    description = "An advanced font engine";
    homepage = "https://graphite.sil.org/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.raskin ];
    mainProgram = "gr2fonttest";
    platforms = platforms.unix;
  };
}
