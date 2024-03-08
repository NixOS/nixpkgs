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
  version = "0.21.1";
  pyproject = true;

  src = fetchPypi {
    pname = "flet_runtime";
    inherit version;
    hash = "sha256-48diTMTWbiZNF4jU6ABgWYsdhNNs3bte7brgdEJE3es=";
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
