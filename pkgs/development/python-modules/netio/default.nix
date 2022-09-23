{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, pyopenssl
}:

buildPythonPackage rec {
  pname = "netio";
  version = "1.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Netio";
    inherit version;
    hash = "sha256-G1NSCchoRjgX2K9URNXsxpp9jxrQo0RgZ00tzWdexGU=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
