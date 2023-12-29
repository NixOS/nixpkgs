{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, flet-core
, httpx
, oauthlib
}:

buildPythonPackage rec {
  pname = "flet-runtime";
  version = "0.17.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "flet_runtime";
    inherit version;
    hash = "sha256-BhVle4Mpx+0YcAaTWk1AvYGuyPFPju1iuF6SLs2uAzU=";
  };

  nativeBuildInputs = [
    poetry-core
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
