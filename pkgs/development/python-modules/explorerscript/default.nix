{ lib
, buildPythonPackage
, fetchFromGitHub
, antlr4
, antlr4-python3-runtime
, igraph
, pygments
, pytestCheckHook
<<<<<<< HEAD
, pythonRelaxDepsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "explorerscript";
<<<<<<< HEAD
  version = "0.1.3";
=======
  version = "0.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-0U5n7e/utmgOTBuTypkBMeHZR7lji6lFimSjbC7hVRM=";
=======
    sha256 = "sha256-REQYyxB2sb/gG54+OkMw+M4Agg9SWfAyqAhiSNnd3tE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    antlr4
<<<<<<< HEAD
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    # antlr output is rebuilt in postPatch step.
    "antlr4-python3-runtime"
    # igraph > 0.10.4 was marked as incompatible by upstream
    # due to regression introduced in 0.10.5, which was fixed
    # in igraph 0.10.6.
    #
    # https://github.com/igraph/python-igraph/issues/693
    "igraph"
  ];

  postPatch = ''
=======
  ];

  postPatch = ''
    sed -i "s/antlr4-python3-runtime.*/antlr4-python3-runtime',/" setup.py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    antlr -Dlanguage=Python3 -visitor explorerscript/antlr/{ExplorerScript,SsbScript}.g4
  '';

  propagatedBuildInputs = [
    antlr4-python3-runtime
    igraph
  ];

  passthru.optional-dependencies.pygments = [
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.pygments;

  pythonImportsCheck = [
    "explorerscript"
  ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/explorerscript";
    description = "A programming language + compiler/decompiler for creating scripts for Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.mit;
    maintainers = with maintainers; [ xfix ];
  };
}
