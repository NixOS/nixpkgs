{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  hatchling,
  pytestCheckHook,
  pyyaml,

  # for passthru.tests
  asgi-csrf,
  connexion,
  fastapi,
  gradio,
  starlette,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-multipart";
  version = "0.0.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kludex";
    repo = "python-multipart";
    tag = finalAttrs.version;
    hash = "sha256-RBRHSpOWLENfrT42/NLhMXb/g5RAcWzbsgPQGN4XZG0=";
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
    changelog = "https://github.com/Kludex/python-multipart/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Streaming multipart parser for Python";
    homepage = "https://github.com/Kludex/python-multipart";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ris ];
  };
})
