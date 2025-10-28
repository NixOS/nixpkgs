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
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pudo";
    repo = "normality";
    tag = version;
    hash = "sha256-X8ssSURC3NiQ1uf2qv1PgCBIYQnmoYVKPn5YPdJG71o=";
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
