{ lib
, fetchPypi
, buildPythonPackage
, tzlocal
, six
, pyjsparser
}:

buildPythonPackage rec {
  pname = "js2py";
  version = "0.74";

  src = fetchPypi {
    pname = "Js2Py";
    inherit version;
    hash = "sha256-OfOmqoRpGA77o8hncnHfJ8MTMv0bRx3xryr1i4e4ly8=";
  };

  propagatedBuildInputs = [
    pyjsparser
    six
    tzlocal
  ];

  # Test require network connection
  doCheck = false;

  pythonImportsCheck = [ "js2py" ];

  meta = with lib; {
    description = "JavaScript to Python Translator & JavaScript interpreter written in 100% pure Python";
    homepage = "https://github.com/PiotrDabkowski/Js2Py";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
