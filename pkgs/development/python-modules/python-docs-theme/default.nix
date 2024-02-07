{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pythonOlder
, sphinx
}:

buildPythonPackage rec {
  pname = "python-docs-theme";
  version = "2024.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python";
    repo = "python-docs-theme";
    rev = "refs/tags/${version}";
    hash = "sha256-5qn/bROc3wekTyYq+e7rLpJjeI8IBByKvrOE4Kw0fjQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
   sphinx
  ];

  pythonImportsCheck = [
    "python_docs_theme"
  ];

  meta = with lib; {
    description = "Sphinx theme for CPython project";
    homepage = "https://github.com/python/python-docs-theme";
    changelog = "https://github.com/python/python-docs-theme/blob/${version}/CHANGELOG.rst";
    license = licenses.psfl;
    maintainers = with maintainers; [ kaction ];
  };
}
