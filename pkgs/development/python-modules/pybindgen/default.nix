{ lib, fetchPypi, buildPythonPackage, isPy3k, setuptools-scm, pygccxml }:
buildPythonPackage rec {
  pname = "PyBindGen";
  version = "0.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b4837d3138ac56863d93fe462f1dac39fb87bd50898e0da4c57fefd645437ac";
  };

  buildInputs = [ setuptools-scm ];

  checkInputs = [ pygccxml ];
  doCheck = (!isPy3k); # Fails to import module 'cxxfilt' from pygccxml on Py3k

  meta = with lib; {
    homepage = "https://github.com/gjcarneiro/pybindgen";
    description = "Python Bindings Generator";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ teto ];
  };
}
