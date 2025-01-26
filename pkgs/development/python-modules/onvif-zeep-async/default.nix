{
  lib,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  httpx,
  pythonOlder,
  setuptools,
  zeep,
}:

buildPythonPackage rec {
  pname = "onvif-zeep-async";
  version = "3.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openvideolibs";
    repo = "python-onvif-zeep-async";
    tag = "v${version}";
    hash = "sha256-guxep37d/MT9dp+sugfH0Ik2aIiwBSpx8x9Jj7OlNvw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ciso8601
    httpx
    zeep
  ];

  pythonImportsCheck = [ "onvif" ];

  # Tests are not shipped
  doCheck = false;

  meta = with lib; {
    description = "ONVIF Client Implementation in Python";
    homepage = "https://github.com/hunterjm/python-onvif-zeep-async";
    changelog = "https://github.com/openvideolibs/python-onvif-zeep-async/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "onvif-cli";
  };
}
