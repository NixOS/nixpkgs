{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hstspreload";
  version = "2026.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "hstspreload";
    tag = finalAttrs.version;
    hash = "sha256-nq9dr8Jd+OvRCXLOQbarXTnUg4QISEty7wvi/P2YUU8=";
  };

  build-system = [ setuptools ];

  # Tests require network connection
  doCheck = false;

  pythonImportsCheck = [ "hstspreload" ];

  meta = {
    description = "Chromium HSTS Preload list";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
