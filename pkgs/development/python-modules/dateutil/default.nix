{ stdenv, buildPythonPackage, fetchPypi, six, setuptools_scm, pytest }:
buildPythonPackage rec {
  pname = "python-dateutil";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six setuptools_scm ];

  checkPhase = ''
    py.test dateutil/test
  '';

  # Requires fixing
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Powerful extensions to the standard datetime module";
    homepage = https://pypi.python.org/pypi/python-dateutil;
    license = "BSD-style";
  };
}
