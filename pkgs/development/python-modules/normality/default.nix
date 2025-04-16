{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  text-unidecode,
  charset-normalizer,
  chardet,
  banal,
  pyicu,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "normality";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pudo";
    repo = "normality";
    rev = version;
    hash = "sha256-RsZP/GkEuPKGZK2+/57kvMwm9vk0FTKN2/XtOmfoZxA=";
  };

  buildInputs = [ hatchling ];

  propagatedBuildInputs = [
    charset-normalizer
    text-unidecode
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
