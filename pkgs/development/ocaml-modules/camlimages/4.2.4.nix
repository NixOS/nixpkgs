{ stdenv
, lib
, fetchFromGitLab
, ocaml
, findlib
, omake
, graphicsmagick
, libpng
, libjpeg
, libexif
, libtiff
, libXpm
, freetype
, giflib
, ghostscript
}:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.02" && lib.versionOlder ocaml.version "4.10")
  "camlimages 4.2.4 is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  pname = "camlimages";
  version = "4.2.4";

  src = fetchFromGitLab {
    owner = "camlspotter";
    repo = pname;
    rev = "c4f0ec4178fd18cb85872181965c5f020c349160";
    sha256 = "17hvsql5dml7ialjcags8wphs7w6z88b2rgjir1382bg8vn62bkr";
  };

  strictDeps = true;

  nativeBuildInputs = [
    omake
    ocaml
    findlib
    graphicsmagick
  ];

  propagatedBuildInputs = [
    libpng
    libjpeg
    libexif
    libtiff
    libXpm
    freetype
    giflib
    ghostscript
  ];

  buildPhase = ''
    runHook preBuild
    omake
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    omake install
    runHook postInstall
  '';

  createFindlibDestdir = true;

  meta = with lib; {
    # 4.2.5 requires OCaml >= 4.06
    branch = "4.2.4";
    # incompatible with omake >= 0.10
    broken = true;
    homepage = "https://gitlab.com/camlspotter/camlimages";
    description = "OCaml image processing library";
    license = licenses.lgpl2Only;
    maintainers = [
      maintainers.vbgl
      maintainers.sternenseemann
    ];
  };
}
