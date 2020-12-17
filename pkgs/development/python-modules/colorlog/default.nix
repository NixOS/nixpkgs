{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "colorlog";
  version = "4.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54e5f153419c22afc283c130c4201db19a3dbd83221a0f4657d5ee66234a2ea4";
  };

  checkInputs = [ pytest ];

  # tests are no longer packaged in pypi
  doCheck = false;
  checkPhase = ''
    py.test -p no:logging
  '';

  pythonImportsCheck =  [ "colorlog" ];

  meta = with stdenv.lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
