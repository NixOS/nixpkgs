{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pycryptodome,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymitsubishi";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymitsubishi";
    repo = "pymitsubishi";
    tag = "v${version}";
    hash = "sha256-Y+peVtaPWuvgM+2x7bIuwCicscv6xkZHzqpFSyiJQWQ=";
  };

  postPatch = ''
    # make sure pyproject.toml specifies the correct version
    grep -qF 'version = "${version}"' pyproject.toml
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pymitsubishi" ];

  meta = {
    description = "Library for controlling and monitoring Mitsubishi MAC-577IF-2E air conditioners";
    homepage = "https://github.com/pymitsubishi/pymitsubishi";
    changelog = "https://github.com/pymitsubishi/pymitsubishi/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uvnikita ];
  };
}
