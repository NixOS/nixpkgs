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
  arg-complete,
  camlidl,
  yojson,
  zarith,
}:

buildDunePackage rec {
  pname = "mopsa";
  version = "1.1";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitLab {
    owner = "mopsa";
    repo = "mopsa-analyzer";
    tag = "v${version}";
    hash = "sha256-lO5dtGAl1dq8oJco/hPXrAbN05rKc62Zrci/8CLrQ0c=";
  };

  nativeBuildInputs = [
    clang
    libllvm
    menhir
  ];

  buildInputs = [
    arg-complete
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
    description = "Modular and Open Platform for Static Analysis using Abstract Interpretation";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
