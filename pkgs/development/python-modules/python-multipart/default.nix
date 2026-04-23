{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "CVE-2026-40347-part-1.patch";
      url = "https://github.com/Kludex/python-multipart/commit/6a7b76dd2653d99d8e5981d7ff09a4a047750b37.patch";
      hash = "sha256-W1nyYMMoaf+lsNze3ppPeAXN+swG1dScDibazePSt+k=";
    })
    ./CVE-2026-40347-part-2.patch
  ];

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

  meta = {
    changelog = "https://github.com/Kludex/python-multipart/blob/${src.tag}/CHANGELOG.md";
    description = "Streaming multipart parser for Python";
    homepage = "https://github.com/Kludex/python-multipart";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ris ];
  };
}
