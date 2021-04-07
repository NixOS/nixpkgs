{ lib, fetchFromGitHub, buildPythonPackage, isPy27, requests }:

buildPythonPackage rec {
  pname = "bravia-tv";
  version = "1.0.8";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "dcnielsen90";
    repo = "python-bravia-tv";
    rev = "v${version}";
    sha256 = "0djwy4z1y173q3mnbngp754yrwzmm6h3x0rshvrvd64b78x1bsmp";
  };

  propagatedBuildInputs = [ requests ];

  # package does not include tests
  doCheck = false;

  pythonImportsCheck = [ "bravia_tv" ];

  meta = with lib; {
    homepage = "https://github.com/dcnielsen90/python-bravia-tv";
    description = "Python library for Sony Bravia TV remote control";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
