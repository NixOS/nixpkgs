{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  mock,
  pyyaml,

  # for passthru.tests
  asgi-csrf,
  connexion,
  fastapi,
  gradio,
  starlette,
}:

buildPythonPackage rec {
  pname = "python-multipart";
  version = "0.0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kludex";
    repo = "python-multipart";
    tag = version;
    hash = "sha256-y8wLGRvc7xSmkSyK77Tl5V6mMneS+dtmqBLZOhvmRSY=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "python_multipart" ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pyyaml
  ];

  passthru.tests = {
    inherit
      asgi-csrf
      connexion
      fastapi
      gradio
      starlette
      ;
  };

  meta = with lib; {
    changelog = "https://github.com/Kludex/python-multipart/blob/${src.tag}/CHANGELOG.md";
    description = "Streaming multipart parser for Python";
    homepage = "https://github.com/Kludex/python-multipart";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
