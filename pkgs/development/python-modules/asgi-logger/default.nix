{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  asgiref,
}:

buildPythonPackage rec {
  pname = "asgi-logger";
  version = "0.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-son1ML9J0UMgJCpWdYD/yK0FO6VmfuzifSWpeCLToKo=";
  };

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [ asgiref ];

  # tests are not in the pypi release, and there are no tags/release corresponding to the pypi releases in the github
  doCheck = false;
  pythonImportsCheck = [ "asgi_logger" ];

  meta = with lib; {
    description = "Access logger for ASGI servers";
    homepage = "https://github.com/Kludex/asgi-logger";
    license = licenses.mit;
    maintainers = teams.wdz.members;
  };
}
