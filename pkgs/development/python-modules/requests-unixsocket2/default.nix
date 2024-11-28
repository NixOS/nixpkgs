{
  lib,
  buildPythonPackage,
  fetchPypi,

  pbr,

  requests,
  poetry-core,

  pytestCheckHook,
  waitress,
}:

buildPythonPackage rec {
  pname = "requests-unixsocket2";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "requests_unixsocket2";
    hash = "sha256-kpxY7MWYHz0SdmHOueyMduDwjTHFLkSrFGKsDc1VtfU=";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    requests
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    waitress
  ];

  pythonImportsCheck = [ "requests_unixsocket" ];

  meta = with lib; {
    description = "Use requests to talk HTTP via a UNIX domain socket";
    homepage = "https://gitlab.com/thelabnyc/requests-unixsocket2";
    license = licenses.bsd0;
    maintainers = with maintainers; [ mikut ];
  };
}
