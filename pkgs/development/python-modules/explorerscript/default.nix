{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  antlr4,
  antlr4-python3-runtime,
  igraph,
  pygments,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "explorerscript";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-dGbzZYEFEWE5bUz+647pPzP4Z/XmrJU82jNT4ZBRNHk=";
  };

  nativeBuildInputs = [
    antlr4
    setuptools
  ];

  pythonRelaxDeps = [
    # antlr output is rebuilt in postPatch step.
    "antlr4-python3-runtime"
    # igraph > 0.10.4 was marked as incompatible by upstream
    # due to a breaking change introduced in 0.10.5. Later versions reverted
    # this change, and introduced a deprecation warning instead.
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

  optional-dependencies.pygments = [ pygments ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.pygments;

  pythonImportsCheck = [ "explorerscript" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/explorerscript";
    description = "Programming language + compiler/decompiler for creating scripts for Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.mit;
    maintainers = with maintainers; [ marius851000 ];
  };
}
