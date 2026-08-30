{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pandoc,
  pandocfilters,
  poetry-core,
  replaceVars,
  texliveSmall,
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JessicaTegner";
    repo = "pypandoc";
    tag = "v${version}";
    hash = "sha256-h0Ur5kWyKz1NCEMdnE0eNCYMAEqjx3g/tnfXs1h9zCs=";
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

  meta = {
    description = "Thin wrapper for pandoc";
    homepage = "https://github.com/JessicaTegner/pypandoc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sternenseemann
      bennofs
    ];
  };
}
