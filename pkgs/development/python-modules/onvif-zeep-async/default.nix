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
  version = "3.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openvideolibs";
    repo = "python-onvif-zeep-async";
    tag = "v${version}";
    hash = "sha256-jWlMjBcGyBcmyDUxAc8UKB5SFcgB1+KvnSPhJxzwCa8=";
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
    changelog = "https://github.com/openvideolibs/python-onvif-zeep-async/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "onvif-cli";
  };
}
