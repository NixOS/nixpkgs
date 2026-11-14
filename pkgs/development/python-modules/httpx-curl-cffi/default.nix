{
  lib,
  buildPythonPackage,
  fetchPypi,
  pdm-backend,
  curl-cffi,
  httpx,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "httpx-curl-cffi";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    pname = "httpx_curl_cffi";
    inherit (finalAttrs) version;
    hash = "sha256-F37plo6doUJAcBeBbMP7CKsoGxNPdzqTWbakZQpsgfM=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    curl-cffi
    httpx
    typing-extensions
  ];

  pythonImportsCheck = [
    "httpx_curl_cffi"
  ];

  meta = {
    description = "Httpx transport for curl_cffi (python bindings for curl-impersonate";
    homepage = "https://pypi.org/project/httpx-curl-cffi";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ xanderio ];
  };
})
