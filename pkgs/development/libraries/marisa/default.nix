{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "marisa";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "s-yata";
    repo = "marisa-trie";
    rev = "v${version}";
    sha256 = "0z4bf55np08q3cbi6gvj3cpw3zp8kf2d0jq6k74pjk066m7rapbb";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage    = https://github.com/s-yata/marisa-trie;
    description = "Static and space-efficient trie data structure library";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms   = platforms.all;
  };
}
