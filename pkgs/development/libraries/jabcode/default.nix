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
  version = "unstable-2021-02-16";
  src = fetchFromGitHub {
    repo = "jabcode";
    owner = "jabcode";
    rev = "e342b647525fa294127930d836b54a6b21957cdc";
    sha256 = "04ngw5aa43q7kxfn1v8drmir2i2qakvq0ni0lgf0zw8150mww52x";
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
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/jabcode.x86_64-darwin
  };
}
