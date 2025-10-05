{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  text-unidecode,
  unidecode,
}:

buildPythonPackage rec {
  pname = "python-slugify";
  version = "8.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "un33k";
    repo = "python-slugify";
    tag = "v${version}";
    hash = "sha256-zReUMIkItnDot3XyYCoPUNHrrAllbClWFYcxdTy3A30=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ text-unidecode ];

  optional-dependencies = {
    unidecode = [ unidecode ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test.py" ];

  pythonImportsCheck = [ "slugify" ];

  meta = with lib; {
    description = "Python Slugify application that handles Unicode";
    mainProgram = "slugify";
    homepage = "https://github.com/un33k/python-slugify";
    changelog = "https://github.com/un33k/python-slugify/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
