{ stdenv, fetchPypi, buildPythonPackage, setuptools_scm
, pytest
}:
buildPythonPackage rec {
  pname = "cxxfilt";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mkxiaw8p9vwmk7np63hjnmkb327454jyrg8lcfbwfahmqk1zi3v";
  };

  buildInputs = [ setuptools_scm ];
  # propagatedBuildInputs = [ cxxfilt pygccxml ];

  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    homepage = https://github.com/afg984/python-cxxfilt;
    description = "Demangling C++ symbols in Python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ teto ];
  };
}



