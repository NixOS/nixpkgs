{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pysimplesoap";
  version = "1.16.2";

  src = fetchPypi {
    inherit version;
    pname = "PySimpleSOAP";
    sha256 = "sha256-sbv00NCt/5tlIZfWGqG3ZzGtYYhJ4n0o/lyyUJFtZ+E=";
  };

  # Tests fail with Python3
  # https://github.com/pysimplesoap/pysimplesoap/issues/107
  doCheck = false;

  pythonImportsCheck = [ "pysimplesoap" ];

  meta = with lib; {
    description = "Python simple and lightweight SOAP Library";
    homepage = "https://github.com/pysimplesoap/pysimplesoap";
    license = licenses.gpl3;
    maintainers = with maintainers; [ onny ];
  };
}
