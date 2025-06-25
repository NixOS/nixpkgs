{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pythonOlder,
}:

buildPythonPackage {
  pname = "pyspinel";
  version = "unstable-2021-08-19";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openthread";
    repo = "pyspinel";
    rev = "50d104e29eacd92d229f0b7179ec1067f5851c17";
    sha256 = "0s2r00zb909cq3dd28i91qbl0nz8cga3g98z84gq5jqkjpiy8269";
  };

  propagatedBuildInputs = [ pyserial ];

  # Tests are out-dated
  doCheck = false;

  pythonImportsCheck = [ "spinel" ];

  meta = with lib; {
    description = "Interface to the OpenThread Network Co-Processor (NCP)";
    homepage = "https://github.com/openthread/pyspinel";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
