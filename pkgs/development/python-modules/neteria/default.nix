{ lib, buildPythonPackage, fetchFromGitHub, rsa }:

buildPythonPackage rec {
  pname = "neteria";
  version = "1.0.3.160123.05";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "Neteria";
    rev = "1a8c976eb2beeca0a5a272a34ac58b2c114495a4";
    sha256 = "1c2fa0d4k2n3b88ac8awajqnfbar2y77zhsxa3wg0hix8lgkmgz3";
  };

  propagatedBuildInputs = [ rsa ];

  meta = {
    homepage = "https://github.com/ShadowBlip/Neteria";
    description = "Open source game networking framework for Python";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ geistesk ];
  };
}
