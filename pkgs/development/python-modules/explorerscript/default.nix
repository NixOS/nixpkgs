{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, antlr4
, antlr4-python3-runtime
, igraph
, pygments
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "explorerscript";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "1vzyliiyrxx8l9sfbqcyr4xn5swd7znkxy69kn0vb5rban8hm9c1";
  };

  nativeBuildInputs = [
    antlr4
  ];

  patches = [
    # https://github.com/SkyTemple/ExplorerScript/pull/17
    (fetchpatch {
      url = "https://github.com/SkyTemple/ExplorerScript/commit/47d8b3d246881d675a82b4049b87ed7d9a0e1b15.patch";
      sha256 = "0sadw9l2nypl2s8lw526lvbdj4rzqdvrjncx4zxxgyp3x47csb48";
    })
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
