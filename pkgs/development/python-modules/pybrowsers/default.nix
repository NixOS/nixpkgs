{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybrowsers";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = "browsers";
    tag = finalAttrs.version;
    hash = "sha256-MpTCeu2rxIx6JByosL2C3hayrMIfKD/2kZT3AJpjKZw=";
  };

  build-system = [ poetry-core ];

  # Tests want to interact with actual browsers
  doCheck = false;

  pythonImportsCheck = [ "browsers" ];

  meta = {
    description = "Python library for detecting and launching browsers";
    homepage = "https://github.com/roniemartinez/browsers";
    changelog = "https://github.com/roniemartinez/browsers/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
