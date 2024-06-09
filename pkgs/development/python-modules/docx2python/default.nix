{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docx2python";
  version = "2.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ShayHill";
    repo = "docx2python";
    rev = "refs/tags/${version}";
    hash = "sha256-SavRYnNbESRQh9Elk8qCt/qdI2x+sYZJFMYy+Gojg2k=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ lxml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "docx2python" ];

  meta = with lib; {
    homepage = "https://github.com/ShayHill/docx2python";
    description = "Extract docx headers, footers, (formatted) text, footnotes, endnotes, properties, and images";
    changelog = "https://github.com/ShayHill/docx2python/blob/${src.rev}/CHANGELOG.md";
    maintainers = [ maintainers.ivar ];
    license = licenses.mit;
  };
}
