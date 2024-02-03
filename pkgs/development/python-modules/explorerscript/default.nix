{ lib
, buildPythonPackage
, fetchFromGitHub
, antlr4
, antlr4-python3-runtime
, igraph
, pygments
, pytestCheckHook
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "explorerscript";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "sha256-0U5n7e/utmgOTBuTypkBMeHZR7lji6lFimSjbC7hVRM=";
  };

  nativeBuildInputs = [
    antlr4
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
