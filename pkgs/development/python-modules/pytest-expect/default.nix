{ buildPythonPackage
, lib
, fetchPypi
, pytest
, u-msgpack-python
, six
}:

buildPythonPackage rec {
  pname = "pytest-expect";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36b4462704450798197d090809a05f4e13649d9cba9acdc557ce9517da1fd847";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ u-msgpack-python six ];

  # Tests in neither the archive nor the repo
  doCheck = false;

  meta = {
    description = "py.test plugin to store test expectations and mark tests based on them";
    homepage = "https://github.com/gsnedders/pytest-expect";
    license = lib.licenses.mit;
  };
}
