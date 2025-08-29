{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  stdenv,
  lib,
}:
buildPythonPackage rec {
  pname = "essentials";
  version = "1.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neoteroi";
    repo = "essentials";
    tag = "v${version}";
    hash = "sha256-wOZ0y6sAPEy2MgcwmM9SjnULe6oWlVuNeC7Zl070CK4=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # time.sleep(0.01) can be up to 0.05s on darwin
    "test_stopwatch"
    "test_stopwatch_with_context_manager"
  ];

  pythonImportsCheck = [ "essentials" ];

  meta = with lib; {
    homepage = "https://github.com/Neoteroi/essentials";
    description = "General purpose classes and functions";
    changelog = "https://github.com/Neoteroi/essentials/releases/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      aldoborrero
      zimbatm
    ];
  };
}
