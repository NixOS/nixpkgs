{ lib
, fetchFromGitHub
, buildPythonPackage
, pbr
, eventlet
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "beka";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "faucetsdn";
    repo = "beka";
    rev = version;
    sha256 = "sha256-rvZjeSmgTG2CxSPHhv1QFM6hVm77v6kIRQiW1TmNlJo=";
  };

  # We are installing from a tarball, so pbr will not be able to derive versioning.
  PBR_VERSION = version;

  propagatedBuildInputs = [
    pbr
    eventlet
  ];

  checkInputs = [ pytestCheckHook pytest-cov ];

  meta = with lib; {
    description = "Basic BGP speaker Python module, can send/receive unicast routes in IPv(4|6)";
    homepage = "https://github.com/faucetsdn/beka";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
