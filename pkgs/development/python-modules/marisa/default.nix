{ stdenv, buildPythonPackage, fetchFromGitHub, marisa, swig }:

buildPythonPackage rec {
  pname = "marisa";
  version = "1.3.40";

  src = fetchFromGitHub {
    owner = "s-yata";
    repo  = "marisa-trie";
    rev   = "59e410597981475bae94d9d9eb252c1d9790dc2f";
    sha256 = "0z4bf55np08q3cbi6gvj3cpw3zp8kf2d0jq6k74pjk066m7rapbb";
  };

  nativeBuildInputs = [ swig marisa ];
  buildinputs = [ marisa ];

  sourceRoot = "${src.name}/bindings/python";

  meta = with stdenv.lib; {
    description = "Python binding for marisa package (do not confuse with marisa-trie python bindings)";
    homepage    = https://github.com/s-yata/marisa-trie;
    license     = with licenses; [ bsd2 lgpl2 ];
    maintainers = with maintainers; [ vanzef ];
  };
}
