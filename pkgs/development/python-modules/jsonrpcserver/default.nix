{ stdenv
, buildPythonPackage
, fetchFromGitHub
, apply_defaults
, jsonschema
, pytest
}:

buildPythonPackage rec {
  pname = "jsonrpcserver";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "bcb";
    repo = pname;
    rev = version;
    sha256 = "0s1v0q2wrfrds5gj7myy3sk5x7xhjlghc8dia2a8ncb9a6cyx84v";
  };

  propagatedBuildInputs = [ apply_defaults jsonschema ];

  checkInputs = [ pytest ];
  checkPhase = "pytest";

  meta = with stdenv.lib; {
    description = "Send JSON-RPC requests";
    homepage = "https://github.com/bcb/jsonrpcclient";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };

}
