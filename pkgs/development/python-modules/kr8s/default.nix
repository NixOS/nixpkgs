{ buildPythonPackage
, pythonOlder
, fetchFromGitHub
, lib
, hatch-vcs
, hatchling
, anyio
, cryptography
, exceptiongroup
, httpx-ws
, httpx
, python-box
, python-jsonpath
, pyyaml
, asyncache
}:

buildPythonPackage rec {
  pname = "kubernetes";
  version = "0.16.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kr8s-org";
    repo = "kr8s";
    rev = "refs/tags/v${version}";
    hash = "sha256-jI5qAYhBpY6XFFBlIuGNY6/oBYClCbiSzuJY3METmjg=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    anyio
    cryptography
    exceptiongroup
    httpx-ws
    httpx
    python-box
    python-jsonpath
    pyyaml
    asyncache
  ];

  meta = with lib;
    {
      description = "A batteries-included Python client library for Kubernetes that feels familiar for folks who already know how to use kubectl";
      homepage = "https://github.com/kr8s-org/kr8s";
      license = licenses.bsd3;
    };
}
