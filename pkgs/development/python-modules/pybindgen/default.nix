{ stdenv, fetchPypi, buildPythonPackage, setuptools_scm, pygccxml }:
buildPythonPackage rec {
  pname = "PyBindGen";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sl4jn8rildv6f62cab66w791cixhaaxl7gwg9labs099rl74yl6";
  };

  buildInputs = [ setuptools_scm ];

  checkInputs = [ pygccxml ];

  meta = with stdenv.lib; {
    homepage = https://github.com/gjcarneiro/pybindgen;
    description = "Python Bindings Generator";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ teto ];
  };
}


