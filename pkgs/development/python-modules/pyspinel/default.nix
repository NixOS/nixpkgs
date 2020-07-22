{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, future, pyserial, ipaddress
}:

buildPythonPackage rec {
  pname = "pyspinel";
  version = "unstable-2020-06-19";  # no versioned release since 2018
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "openthread";
    repo = pname;
    rev = "e0bb3f8e6f49b593ab248a75de04a71626ae8101";
    sha256 = "0nfmdkgbhmkl82dfxjpwiiarxngm6a3fvdrzpaqp60a4b17pipqg";
  };

  propagatedBuildInputs = [
    future
    ipaddress
    pyserial
  ];

  doCheck = false;
  pythonImportsCheck = [ "spinel" ];

  meta = with lib; {
    description = "Interface to the OpenThread Network Co-Processor (NCP)";
    homepage = "https://github.com/openthread/pyspinel";
    license = licenses.asl20;
    maintainers = with maintainers; [ gebner ];
  };
}
