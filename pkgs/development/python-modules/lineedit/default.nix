{ lib
, buildPythonPackage
, fetchPypi
, pygments
, six
, wcwidth
}:

buildPythonPackage rec {
  pname = "lineedit";
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9HlUeRVONQrZz26L5q06ePEPiSuZZ1ry+BQPLYR/bz8=";
  };

  # Tests not included in PyPI release
  doCheck = false;

  propagatedBuildInputs = [
    pygments
    six
    wcwidth
  ];

  pythonImportsCheck = [ "lineedit" ];

  meta = with lib; {
    description = "A readline library based on prompt_toolkit which supports multiple modes.";
    homepage = "https://github.com/randy3k/lineedit";
    license = licenses.mit;
    maintainers = with maintainers; [ jdreaver ];
  };
}
