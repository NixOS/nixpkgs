{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  netaddr,
  six,
  unittestCheckHook,
  fetchPypi,
}:
let
  netaddr_0_8_0 = netaddr.overridePythonAttrs (oldAttrs: rec {
    version = "0.8.0";

    src = fetchPypi {
      pname = "netaddr";
      inherit version;
      hash = "sha256-1sxXx6B7HZ0ukXqos2rozmHDW6P80bg8oxxaDuK1okM=";
    };
  });
in

buildPythonPackage rec {
  pname = "pyrad";
  version = "2.4-unstable-2023-06-13";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pyradius";
    repo = pname;
    rev = "dd34c5a29b46d83b0bea841e85fd72b79f315b87";
    hash = "sha256-U4VVGkDDyN4J/tRDaDGSr2TSA4JmqIoQj5qn9qBAvQU=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    netaddr_0_8_0
    six
  ];

  preCheck = ''
    substituteInPlace tests/testServer.py \
      --replace-warn "def testBind(self):" "def dontTestBind(self):" \
      --replace-warn "def testBindv6(self):" "def dontTestBindv6(self):" \
  '';

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pyrad" ];

  meta = {
    description = "Python RADIUS Implementation";
    homepage = "https://github.com/pyradius/pyrad";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
