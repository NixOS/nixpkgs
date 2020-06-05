{ stdenv
, buildPythonPackage
, fetchFromGitHub
, apply_defaults
, click
, jsonschema
, mock
, pytest
, pytest-asyncio
, aiohttp
, requests
, responses
, pyzmq
, testfixtures
, tornado
, websockets
}:

buildPythonPackage rec {
  pname = "jsonrpcclient";
  version = "3.3.6";

  src = fetchFromGitHub {
    owner = "bcb";
    repo = pname;
    rev = version;
    sha256 = "1cy0y8pwi1dvz1hgbsnys2ck0v5rxmfkgn9qajd8h62cwv2wwjja";
  };

  propagatedBuildInputs = [ apply_defaults click jsonschema ];

  checkInputs = [ mock pytest pytest-asyncio aiohttp requests responses pyzmq testfixtures tornado websockets ];
  checkPhase = "pytest";

  meta = with stdenv.lib; {
    description = "Send JSON-RPC requests";
    homepage = "https://github.com/bcb/jsonrpcclient";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };

}
