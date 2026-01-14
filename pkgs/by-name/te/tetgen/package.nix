{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "tetgen";
  version = "1.6.0";

  src = fetchurl {
    url = "http://wias-berlin.de/software/tetgen/1.5/src/tetgen${version}.tar.gz";
    sha256 = "sha256-h7XmHr06Rx/E8s3XEkwrEd1mOfT+sflBpdL1EQ0Fzjk=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,include}
    cp tetgen $out/bin
    cp libtet.a $out/lib
    cp ../tetgen.{cxx,h} $out/include

    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Quality Tetrahedral Mesh Generator and 3D Delaunay Triangulator";
    mainProgram = "tetgen";
    homepage = "http://tetgen.org/";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.unix;
  };
}
