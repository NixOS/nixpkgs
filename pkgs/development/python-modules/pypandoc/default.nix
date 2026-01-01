{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pandoc,
  pandocfilters,
  poetry-core,
  pythonOlder,
  replaceVars,
  texliveSmall,
}:

buildPythonPackage rec {
  pname = "pypandoc";
<<<<<<< HEAD
  version = "1.16.2";
=======
  version = "1.13";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JessicaTegner";
    repo = "pypandoc";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-h0Ur5kWyKz1NCEMdnE0eNCYMAEqjx3g/tnfXs1h9zCs=";
=======
    hash = "sha256-9fpits8O/50maM/e1lVVqBoTwUmcI+/IAYhVX1Pt6ZE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    (replaceVars ./static-pandoc-path.patch {
      pandoc = "${lib.getBin pandoc}/bin/pandoc";
      pandocVersion = pandoc.version;
    })
    ./skip-tests.patch
  ];

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    texliveSmall
    pandocfilters
  ];

  pythonImportsCheck = [ "pypandoc" ];

<<<<<<< HEAD
  meta = {
    description = "Thin wrapper for pandoc";
    homepage = "https://github.com/JessicaTegner/pypandoc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Thin wrapper for pandoc";
    homepage = "https://github.com/JessicaTegner/pypandoc";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      sternenseemann
      bennofs
    ];
  };
}
