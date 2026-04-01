{
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  lib,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "expecttest";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "expecttest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/BMaQD3ZgYiprRYZ/fIlW7mStyFGzsjqup62tegBP7Y=";
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
})
