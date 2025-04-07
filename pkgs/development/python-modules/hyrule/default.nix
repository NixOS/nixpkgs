{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hyrule";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hylang";
    repo = "hyrule";
    tag = version;
    hash = "sha256-HSs5YUbhdaOgpBaxXe9LibJN4G3UJvEvEdnYt6ORQBo=";
  };

  build-system = [ setuptools ];

  dependencies = [ hy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Some tests depends on hy on PATH
  preCheck = "PATH=${hy}/bin:$PATH";

  pythonImportsCheck = [ "hyrule" ];

  meta = with lib; {
    description = "Utility library for the Hy programming language";
    homepage = "https://github.com/hylang/hyrule";
    changelog = "https://github.com/hylang/hyrule/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
