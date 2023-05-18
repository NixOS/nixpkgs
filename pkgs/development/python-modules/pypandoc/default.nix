{ lib
, buildPythonPackage
, fetchFromGitHub
, pandoc
, pandocfilters
, pythonOlder
, substituteAll
, texlive
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.10";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JessicaTegner";
    repo = pname;
    rev = "v${version}";
    hash = "sha256:05m585l4sipjzpkrv4yj5s7w45yxhxlym55lkhnavsshlvisinkz";
  };

  patches = [
    (substituteAll {
      src = ./static-pandoc-path.patch;
      pandoc = "${lib.getBin pandoc}/bin/pandoc";
      pandocVersion = pandoc.version;
    })
    ./skip-tests.patch
  ];

  nativeCheckInputs = [
    texlive.combined.scheme-small
    pandocfilters
  ];

  pythonImportsCheck = [
    "pypandoc"
  ];

  meta = with lib; {
    description = "Thin wrapper for pandoc";
    homepage = "https://github.com/JessicaTegner/pypandoc";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann bennofs ];
  };
}
