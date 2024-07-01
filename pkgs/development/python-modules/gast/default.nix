{
  lib,
  astunparse,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gast";
  version = "0.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = pname;
    rev = version;
    hash = "sha256-0y2bHT7YEfTvDxTm6yLl3GmnPUYEieoGEnwkzfA6mOg=";
  };

  nativeCheckInputs = [
    astunparse
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gast" ];

  meta = with lib; {
    description = "Compatibility layer between the AST of various Python versions";
    homepage = "https://github.com/serge-sans-paille/gast/";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      jyp
      cpcloud
    ];
  };
}
