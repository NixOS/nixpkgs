{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools-scm
, aiohttp
, pytz
, voluptuous
}:

buildPythonPackage rec {
  pname = "pygti";
  version = "0.9.3";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vigonotion";
    repo = "pygti";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-5Pc6gAI3xICS+f7tYwC9OVOAHJSW8AGPOvPYs0/6/iI=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    aiohttp
    pytz
    voluptuous
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pygti.auth"
    "pygti.exceptions"
    "pygti.gti"
  ];

  meta = with lib; {
    description = "Access public transport information in Hamburg, Germany";
    homepage = "https://github.com/vigonotion/pygti";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
