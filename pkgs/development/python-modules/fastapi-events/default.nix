{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "fastapi-events";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "melvinkcx";
    repo = "fastapi-events";
    rev = "v${version}";
    hash = "sha256-dfLZDacu5jb2HcfI1Y2/xCDr1kTM6E5xlHAPratD+Yw=";
  };

  doCheck = false;

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "fastapi_events" ];

  meta = with lib; {
    description = "Asynchronous event dispatching/handling library for FastAPI and Starlette";
    homepage = "https://github.com/melvinkcx/fastapi-events";
    license = licenses.mit;
    maintainers = [ ];
  };
}
