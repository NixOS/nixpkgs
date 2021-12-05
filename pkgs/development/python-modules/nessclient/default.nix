{ lib, asynctest, buildPythonPackage, click, fetchFromGitHub, justbackoff
, pythonOlder, pytest-asyncio, pytestCheckHook }:

buildPythonPackage rec {
  pname = "nessclient";
  version = "0.9.16b2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nickw444";
    repo = pname;
    rev = version;
    sha256 = "1g3q9bv1nn1b8n6bklc05k8pac4cndzfxfr7liky0gnnbri15k81";
  };

  propagatedBuildInputs = [ justbackoff click ];

  checkInputs = [ asynctest pytest-asyncio pytestCheckHook ];

  pythonImportsCheck = [ "nessclient" ];

  meta = with lib; {
    description =
      "Python implementation/abstraction of the Ness D8x/D16x Serial Interface ASCII protocol";
    homepage = "https://github.com/nickw444/nessclient";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
