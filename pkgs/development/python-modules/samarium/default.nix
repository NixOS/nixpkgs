{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  crossandra,
  dahlia,
}:

buildPythonPackage (finalAttrs: {
  pname = "samarium";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samarium-lang";
    repo = "samarium";
    tag = finalAttrs.version;
    hash = "sha256-sOkJ67B8LaIA2cwCHaFnc16lMG8uaegBJCzF6Li77vk=";
  };

  build-system = [ poetry-core ];
  dependencies = [
    crossandra
    dahlia
  ];

  meta = {
    changelog = "https://github.com/samarium-lang/samarium/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Samarium Programming Language";
    license = lib.licenses.mit;
    homepage = "https://samarium-lang.github.io/Samarium";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
