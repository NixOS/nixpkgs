{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hypothesis
, pytestcache
, pytestcov
, pytestflakes
, pytestpep8
, pytest
, mock
, pathlib ? null
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "natsort";
  version = "5.0.3";

  buildInputs = [
    hypothesis
    pytestcache
    pytestcov
    pytestflakes
    pytestpep8
    pytest
    mock
  ]
  # pathlib was made part of standard library in 3.5:
  ++ (lib.optionals (pythonOlder "3.4") [ pathlib ]);

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h87n0jcsi6mgjx1pws6g1lmcn8jwabwxj8hq334jvziaq0plyym";
  };

  meta = {
    description = "Natural sorting for python";
    homepage = https://github.com/SethMMorton/natsort;
    license = lib.licenses.mit;
    broken = true;
  };
}
