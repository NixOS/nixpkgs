{
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  lib,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "expecttest";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "expecttest";
    rev = "683b09a352cc426851adc2e3a9f46e0ab25e4dee"; # no tags
    hash = "sha256-e9/KxPN/w0mrFYgesRGqaiDQ6gor7BpX/5/B0NPtXLY=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "expecttest" ];

  meta = {
    maintainers = [ lib.maintainers.SomeoneSerge ];
    license = lib.licenses.mit;
    description = ''EZ Yang "golden" tests (testing against a reference implementation)'';
    homepage = "https://github.com/pytorch/expecttest";
    platforms = lib.platforms.unix;
  };
}
