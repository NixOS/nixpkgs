{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  clang,
  libclang,
  libllvm,
  flint,
  mpfr,
  pplite,
  ocaml,
  menhir,
  apron,
  camlidl,
  yojson,
  zarith,
}:

buildDunePackage rec {
  pname = "mopsa";
  version = "1.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitLab {
    owner = "mopsa";
    repo = "mopsa-analyzer";
    rev = "v${version}";
    hash = "sha256-nGnWwV7g3SYgShbXGUMooyOdFwXFrQHnQvlc8x9TAS4=";
  };

  nativeBuildInputs = [
    clang
    libllvm
    menhir
  ];

  buildInputs = [
    camlidl
    flint
    libclang
    mpfr
    pplite
  ];

  propagatedBuildInputs = [
    apron
    yojson
    zarith
  ];

  postPatch = ''
    patchShebangs bin
  '';

  buildPhase = ''
    runHook preBuild
    dune build --profile release -p mopsa
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install --profile release --prefix=$bin --libdir=$out/lib/ocaml/${ocaml.version}/site-lib
    runHook postInstall
  '';

  outputs = [
    "bin"
    "out"
  ];

  meta = {
    license = lib.licenses.lgpl3Plus;
    homepage = "https://mopsa.lip6.fr/";
    description = "A Modular and Open Platform for Static Analysis using Abstract Interpretation";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
