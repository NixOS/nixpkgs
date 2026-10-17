{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
}:

buildPythonPackage {
  pname = "pyspinel";
  version = "1.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openthread";
    repo = "pyspinel";
    rev = "50d104e29eacd92d229f0b7179ec1067f5851c17";
    hash = "sha256-yQjk45UTy4IfQR+lN9Rj6FtAFw4pItHawCyBtD4AWWg=";
  };

  propagatedBuildInputs = [ pyserial ];

  # Tests are out-dated
  doCheck = false;

  pythonImportsCheck = [ "spinel" ];

  meta = {
    description = "Interface to the OpenThread Network Co-Processor (NCP)";
    homepage = "https://github.com/openthread/pyspinel";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
