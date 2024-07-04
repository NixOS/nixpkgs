{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  text-unidecode,
  charset-normalizer,
  chardet,
  banal,
  pyicu,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "normality";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pudo";
    repo = "normality";
    rev = version;
    hash = "sha256-cGQpNhUqlT2B9wKDoDeDmyCNQLwWR7rTCLxnPHhMR0w=";
  };

  buildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    charset-normalizer
    text-unidecode
    chardet
    banal
    pyicu
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "normality" ];

  meta = with lib; {
    description = "Micro-library to normalize text strings";
    homepage = "https://github.com/pudo/normality";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
