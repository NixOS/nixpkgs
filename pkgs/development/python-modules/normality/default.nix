{ lib
, fetchFromGitHub
, buildPythonPackage
, text-unidecode
, chardet
, banal
, pyicu
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "normality";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "pudo";
    repo = "normality";
    rev = version;
    sha256 = "n8Ycm5DeFItmMJTolazZKGIyN7CTg2ajDCwi/UqzVe8=";
  };

  propagatedBuildInputs = [
    text-unidecode
    chardet
    banal
    pyicu
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "normality"
  ];

  meta = with lib; {
    description = "Micro-library to normalize text strings";
    homepage = "https://github.com/pudo/normality";
    license = licenses.mit;
    maintainers = [ ];
  };
}
