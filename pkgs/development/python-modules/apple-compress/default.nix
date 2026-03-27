{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  lib,
  loguru,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "apple-compress";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m1stadev";
    repo = "apple-compress";
    tag = "v${version}";
    hash = "sha256-uM5HFkhvzAIfdAglPUvJfckngjUPSZqydyVcPcdtyfs=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    click
    loguru
  ];

  pythonImportsCheck = [ "apple_compress" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/m1stadev/apple-compress/releases/tag/${src.tag}";
    description = "Python bindings for Apple's libcompression";
    homepage = "https://github.com/m1stadev/apple-compress";
    license = lib.licenses.mit;
    mainProgram = "acompress";
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.darwin;
  };
}
