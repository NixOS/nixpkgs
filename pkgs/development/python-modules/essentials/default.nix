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
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neoteroi";
    repo = "essentials";
    rev = "v${version}";
    hash = "sha256-WMHjBVkeSoQ4Naj1U7Bg9j2hcoErH1dx00BPKiom9T4=";
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
    changelog = "https://github.com/Neoteroi/essentials/releases/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      aldoborrero
      zimbatm
    ];
  };
}
