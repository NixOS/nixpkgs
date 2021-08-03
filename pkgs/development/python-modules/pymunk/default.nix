{ lib
, buildPythonPackage
, fetchPypi
, python
, cffi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pymunk";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "04jqqd2y0wzzkqppbl08vyzgbcpl5qj946w8da2ilypqdx7j2akp";
  };

  propagatedBuildInputs = [ cffi ];

  preBuild = ''
    ${python.interpreter} setup.py build_ext --inplace
  '';

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [
    "pymunk/tests"
  ];

  meta = with lib; {
    description = "2d physics library";
    homepage = "https://www.pymunk.org";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ angustrau ];
  };
}
