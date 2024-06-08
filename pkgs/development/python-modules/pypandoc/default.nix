{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pandoc,
  pandocfilters,
  poetry-core,
  pythonOlder,
  substituteAll,
  texliveSmall,
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.13";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JessicaTegner";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9fpits8O/50maM/e1lVVqBoTwUmcI+/IAYhVX1Pt6ZE=";
  };

  patches = [
    (substituteAll {
      src = ./static-pandoc-path.patch;
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

  meta = with lib; {
    description = "Thin wrapper for pandoc";
    homepage = "https://github.com/JessicaTegner/pypandoc";
    license = licenses.mit;
    maintainers = with maintainers; [
      sternenseemann
      bennofs
    ];
  };
}
