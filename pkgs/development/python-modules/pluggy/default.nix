{ stdenv, buildPythonPackage, fetchPypi, pytest, six, doCheck ? true }:
buildPythonPackage rec {
  pname = "pluggy";
  version = "0.6.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f8ae7f5bdf75671a718d2daf0a64b7885f74510bcd98b1a0bb420eb9a9d0cff";
  };

  # Circular dependency on pytest
  #inherit doCheck;

  checkInputs = stdenv.lib.optionals doCheck [ pytest ];

  checkPhase = ''
    rm tox.ini
    pytest testing/
  '';

  meta = with stdenv.lib; {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://pypi.python.org/pypi/pluggy";
    license = licenses.mit;
    maintainers = with maintainers; [ jgeerds ];
  };
}
