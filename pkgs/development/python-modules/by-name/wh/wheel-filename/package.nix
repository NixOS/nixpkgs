{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wheel-filename";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "wheel-filename";
    tag = "v${version}";
    hash = "sha256-KAuUrrSq6HJAy+5Gj6svI4M6oV6Fsle1A79E2q2FKW8=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "wheel_filename" ];

  meta = {
    description = "Parse wheel filenames";
    homepage = "https://github.com/jwodder/wheel-filename";
    changelog = "https://github.com/wheelodex/wheel-filename/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ayazhafiz ];
    mainProgram = "wheel-filename";
  };
}
