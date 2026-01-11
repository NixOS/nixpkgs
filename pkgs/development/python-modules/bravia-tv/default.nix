{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "bravia-tv";
  version = "1.0.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dcnielsen90";
    repo = "python-bravia-tv";
    rev = "v${version}";
    hash = "sha256-g47bDd5bZl0jad3o6T1jJLcnZj8nx944kz3Vxv8gD2U=";
  };

  propagatedBuildInputs = [ requests ];

  # Package does not include tests
  doCheck = false;

  pythonImportsCheck = [ "bravia_tv" ];

  meta = {
    homepage = "https://github.com/dcnielsen90/python-bravia-tv";
    description = "Python library for Sony Bravia TV remote control";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
