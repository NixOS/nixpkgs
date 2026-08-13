{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pycountry,
  repoze-lru,
}:

buildPythonPackage rec {
  pname = "pycountry-convert";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CV0xD3Rr8qXvcTs6gu6iiicmIoYiN2Wx576KXE+n6bk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    "pprintpp"
    "pytest"
    "pytest-cov"
    "repoze-lru"
    "pytest-mock"
  ];

  propagatedBuildInputs = [
    pycountry
    repoze-lru
  ];

  pythonImportsCheck = [ "pycountry_convert" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Python conversion functions between ISO country codes, countries, and continents";
    homepage = "https://github.com/jefftune/pycountry-convert";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
