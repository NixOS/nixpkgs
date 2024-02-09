{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonRelaxDepsHook
, flet-core
, httpx
, oauthlib
}:

buildPythonPackage rec {
  pname = "flet-runtime";
  version = "0.19.0";
  pyproject = true;

  src = fetchPypi {
    pname = "flet_runtime";
    inherit version;
    hash = "sha256-no2oDGZG1svrOZLNAao279qeHwyk5SGibDG4UqpriiU=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "httpx"
  ];

  propagatedBuildInputs = [
    flet-core
    httpx
    oauthlib
  ];

  pythonImportsCheck = [
    "flet_runtime"
  ];

  meta = {
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    description = "A base package for Flet desktop and Flet mobile";
    homepage = "https://flet.dev/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.wegank ];
  };
}
