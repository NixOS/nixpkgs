{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  xmltodict,
  responses,
  python,
}:

buildPythonPackage rec {
  pname = "qnapstats";
  version = "0.5.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "colinodell";
    repo = "python-qnapstats";
    rev = "refs/tags/${version}";
    hash = "sha256-dpxl6a61h8zB7eS/2lxG+2//bOTzV6s4T1W+DVj0fnI=";
  };

  propagatedBuildInputs = [
    requests
    xmltodict
  ];

  nativeCheckInputs = [ responses ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/test-models.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "qnapstats" ];

  meta = {
    description = "Python API for obtaining QNAP NAS system stats";
    homepage = "https://github.com/colinodell/python-qnapstats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
