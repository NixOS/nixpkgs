{ lib
, buildPythonPackage
, fetchPypi
, lineedit
, pygments
, pytest-runner
, rchitect
, six
}:

buildPythonPackage rec {
  pname = "radian";
  version = "0.5.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "hM2IDcBjOFIRC3SdNO9PSM8TqI1ga1GvCFQkqf4Tyto=";
  };

  buildInputs = [
    pytest-runner
  ];

  # Tests not included in PyPI release
  doCheck = false;

  propagatedBuildInputs = [
    lineedit
    pygments
    rchitect
    six
  ];

  pythonImportsCheck = [ "radian" ];

  meta = with lib; {
    description = "A 21 century R console.";
    homepage = "https://github.com/randy3k/radian";
    license = licenses.mit;
    maintainers = with maintainers; [ jdreaver ];
  };
}
