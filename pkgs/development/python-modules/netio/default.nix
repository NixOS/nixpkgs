{ lib
, buildPythonPackage
, fetchPypi
, pyopenssl
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "netio";
  version = "1.0.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname ="Netio";
    inherit version;
    hash = "sha256-+fGs7ZwvspAW4GlO5Hx+gNb+7Mhl9HC4pijHyk+8PYs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
    pyopenssl
  ];

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
