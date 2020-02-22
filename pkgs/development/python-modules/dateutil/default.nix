{ stdenv, buildPythonPackage, fetchPypi, six, setuptools_scm, pytest }:
buildPythonPackage rec {
  pname = "python-dateutil";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c";
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
