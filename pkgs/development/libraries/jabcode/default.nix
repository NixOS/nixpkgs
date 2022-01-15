{ stdenv
, fetchFromGitHub
, lib
, subproject ? "library" # one of "library", "reader" or  "writer"
, zlib
, libpng
, libtiff
, jabcode
}:
let
  subdir = lib.getAttr subproject {
    "library" = "jabcode";
    "reader" = "jabcodeReader";
    "writer" = "jabcodeWriter";
  };
in
stdenv.mkDerivation rec {
  pname = "jabcode-${subproject}";
  version = "unstable-2020-05-13";
  src = fetchFromGitHub {
    repo = "jabcode";
    owner = "jabcode";
    rev = "a7c25d4f248078f257b014e31c791bfcfcd083e1";
    sha256 = "1c4cv9b0d7r4bxzkwzdv9h651ziq822iya6fbyizm57n1nzdkk4s";
  };

  nativeBuildInputs =
    [ zlib libpng libtiff ]
    ++ lib.optionals (subproject != "library") [ jabcode ];

  preConfigure = "cd src/${subdir}";

  installPhase =
    if subproject == "library" then ''
      mkdir -p $out/lib
      cp build/* $out/lib
    '' else ''
      mkdir -p $out/bin
      cp -RT bin $out/bin
    '';

  meta = with lib; {
    description = "A high-capacity 2D color bar code (${subproject})";
    longDescription = "JAB Code (Just Another Bar Code) is a high-capacity 2D color bar code, which can encode more data than traditional black/white (QR) codes. This is the ${subproject} part.";
    homepage = "https://jabcode.org/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.unix;
  };
}
