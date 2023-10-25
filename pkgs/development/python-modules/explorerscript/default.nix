{ lib
, buildPythonPackage
, fetchFromGitHub
, antlr4
, antlr4-python3-runtime
, igraph
, pygments
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "explorerscript";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "sha256-REQYyxB2sb/gG54+OkMw+M4Agg9SWfAyqAhiSNnd3tE=";
  };

  nativeBuildInputs = [
    antlr4
  ];

  postPatch = ''
    sed -i "s/antlr4-python3-runtime.*/antlr4-python3-runtime',/" setup.py
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
