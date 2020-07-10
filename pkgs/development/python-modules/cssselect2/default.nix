{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, tinycss2
, pytest
, pytestrunner
, pytestcov
, pytest-flake8
, pytest-isort
}:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.3.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c2716f06b5de93f701d5755a9666f2ee22cbcd8b4da8adddfc30095ffea3abc";
  };

  propagatedBuildInputs = [ tinycss2 ];

  checkInputs = [ pytest pytestrunner pytestcov pytest-flake8 pytest-isort ];

  meta = with lib; {
    description = "CSS selectors for Python ElementTree";
    homepage = "https://github.com/Kozea/cssselect2";
    license = licenses.bsd3;
  };
}
