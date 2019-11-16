{ stdenv, fetchPypi, buildPythonPackage, isPy3k, setuptools_scm, pygccxml }:
buildPythonPackage rec {
  pname = "PyBindGen";
  version = "0.20.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5615f6b5d9b8aec86d69acedd050ecb5eb7d1338436c3667e345f800a2658f9f";
  };

  buildInputs = [ setuptools_scm ];

  checkInputs = [ pygccxml ];
  doCheck = (!isPy3k); # Fails to import module 'cxxfilt' from pygccxml on Py3k

  meta = with stdenv.lib; {
    homepage = https://github.com/gjcarneiro/pybindgen;
    description = "Python Bindings Generator";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ teto ];
  };
}
