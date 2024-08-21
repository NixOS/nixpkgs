{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyhomeworks";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RwaVjOhMztQsKD+F++PLcwa0gqfC+8aQmloMVnQJjv8=";
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
