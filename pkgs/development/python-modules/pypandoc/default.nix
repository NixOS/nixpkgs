{ lib
, buildPythonPackage
, fetchFromGitHub
, pandoc
, pandocfilters
<<<<<<< HEAD
, poetry-core
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, substituteAll
, texlive
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.10";
<<<<<<< HEAD
  format = "pyproject";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  nativeBuildInputs = [
    poetry-core
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
