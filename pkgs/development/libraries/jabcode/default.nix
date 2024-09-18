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
  version = "unstable-2022-06-17";
  src = fetchFromGitHub {
    repo = "jabcode";
    owner = "jabcode";
    rev = "ee0e4c88b9f3c1da46d6f679ee8b69c547907c20";
    hash = "sha256-GjRkDWefQFdT4i9hRcQhYsY4beMUIXxy38I5lsQytyA=";
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
    description = "High-capacity 2D color bar code (${subproject})";
    longDescription = "JAB Code (Just Another Bar Code) is a high-capacity 2D color bar code, which can encode more data than traditional black/white (QR) codes. This is the ${subproject} part.";
    homepage = "https://jabcode.org/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/jabcode.x86_64-darwin
  };
}
