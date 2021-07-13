{ lib, buildPythonPackage, fetchFromGitHub, antlr4-python3-runtime, pygments, python-igraph }:

buildPythonPackage rec {
  pname = "explorerscript";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "1vzyliiyrxx8l9sfbqcyr4xn5swd7znkxy69kn0vb5rban8hm9c1";
  };

  propagatedBuildInputs = [ antlr4-python3-runtime python-igraph ];
  checkInputs = [ pygments ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/explorerscript";
    description = "A programming language + compiler/decompiler for creating scripts for Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.mit;
    maintainers = with maintainers; [ xfix ];
  };
}
