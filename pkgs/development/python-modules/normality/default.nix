{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  charset-normalizer,
  chardet,
  banal,
  pyicu,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "normality";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pudo";
    repo = "normality";
    tag = version;
    hash = "sha256-AAxFsdh2pv317hn9vr8Xpz9QPLYEa3KMDcObwR51NWo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    charset-normalizer
    chardet
    banal
    pyicu
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "normality" ];

  meta = {
    description = "Micro-library to normalize text strings";
    homepage = "https://github.com/pudo/normality";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
