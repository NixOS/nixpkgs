{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyhumps";
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nficano";
    repo = "humps";
    tag = "v${version}";
    hash = "sha256-PvfjW56UVCcjd2jJiQW/goVJ1BC8xQ973xuZ6izwclw=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "humps" ];

  meta = {
    description = "Module to convert strings (and dictionary keys) between snake case, camel case and pascal case";
    homepage = "https://github.com/nficano/humps";
    license = with lib.licenses; [ unlicense ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
