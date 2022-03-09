{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.3.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dd0bqhai4k3fj9ydcwmc9hvbmrsklk349ys21w8x4n5xynk2hns";
  };

  pythonImportsCheck = [
    "frozendict"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    pushd test
  '';

  postCheck = ''
    popd
  '';

  meta = with lib; {
    homepage = "https://github.com/slezica/python-frozendict";
    description = "An immutable dictionary";
    license = licenses.mit;
  };
}
