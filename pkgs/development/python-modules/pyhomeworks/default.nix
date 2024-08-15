{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyhomeworks";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9S0SYn4e/qaCRgdwlU4gPaj0eKAQJrYigvAP6eaPzRM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=69.2.0" "setuptools"
  '';

  build-system = [ setuptools ];

  # Project has no real tests
  doCheck = false;

  pythonImportsCheck = [ "pyhomeworks" ];

  meta = with lib; {
    description = "Python interface to Lutron Homeworks Series 4/8";
    homepage = "https://github.com/dubnom/pyhomeworks";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
