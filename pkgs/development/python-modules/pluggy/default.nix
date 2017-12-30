{ stdenv, buildPythonPackage, fetchPypi, pytest, six }:
buildPythonPackage rec {
  pname = "pluggy";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f8ae7f5bdf75671a718d2daf0a64b7885f74510bcd98b1a0bb420eb9a9d0cff";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest testing/
  '';


  meta = with stdenv.lib; {
    description = "A minimalist production ready plugin system";
    homepage = "https://pluggy.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ jgeerds ];
  };
}
