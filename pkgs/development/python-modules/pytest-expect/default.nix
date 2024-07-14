{
  buildPythonPackage,
  lib,
  fetchPypi,
  pytest,
  u-msgpack-python,
  six,
}:

buildPythonPackage rec {
  pname = "pytest-expect";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NrRGJwRFB5gZfQkICaBfThNknZy6ms3FV86VF9of2Ec=";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [
    u-msgpack-python
    six
  ];

  # Tests in neither the archive nor the repo
  doCheck = false;

  meta = {
    description = "py.test plugin to store test expectations and mark tests based on them";
    homepage = "https://github.com/gsnedders/pytest-expect";
    license = lib.licenses.mit;
  };
}
