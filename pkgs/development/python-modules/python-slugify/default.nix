{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  text-unidecode,
  unidecode,
}:

buildPythonPackage rec {
  pname = "python-slugify";
  version = "9.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "un33k";
    repo = "python-slugify";
    tag = "v${version}";
    hash = "sha256-bCOsExVFv+R4T6HQcJK3biyIHOXf5Ax8ZA9jQfno8v4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ text-unidecode ];

  optional-dependencies = {
    unidecode = [ unidecode ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "slugify" ];

  meta = {
    description = "Python Slugify application that handles Unicode";
    mainProgram = "slugify";
    homepage = "https://github.com/un33k/python-slugify";
    changelog = "https://github.com/un33k/python-slugify/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
