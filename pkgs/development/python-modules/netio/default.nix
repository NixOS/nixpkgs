{ lib
, buildPythonPackage
, fetchFromGitHub
, pyopenssl
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "netio";
  version = "1.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "netioproducts";
    repo = "PyNetio";
    rev = "v${version}";
    hash = "sha256-07GzT9j27KmrTQ7naIdlIz7HB9knHpjH4mQhlwUKucU=";
  };

  propagatedBuildInputs = [
    requests
    pyopenssl
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "import py2exe" ""
  '';

  pythonImportsCheck = [
    "Netio"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Module for interacting with NETIO devices";
    homepage = "https://github.com/netioproducts/PyNetio";
    changelog = "https://github.com/netioproducts/PyNetio/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
