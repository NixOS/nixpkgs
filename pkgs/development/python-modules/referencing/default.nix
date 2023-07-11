{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, hatch-vcs
, hatchling
, jsonschema
, pytest-subtests
, pytestCheckHook
, pythonOlder
, rpds-py
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "referencing";
  version = "0.29.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "referencing";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-Mdbzv0xNMnU8b9ynqX7kXUkTasx4pCymWXs5RcwRmSc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    sed -i "/Topic/d" pyproject.toml
  '';

  nativeBuildInputs = [
    hatch-vcs
    hatchling
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    rpds-py
  ];

  nativeCheckInputs = [
    jsonschema
    pytest-subtests
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "referencing"
  ];

  meta = with lib; {
    description = "Cross-specification JSON referencing";
    homepage = "https://github.com/python-jsonschema/referencing";
    changelog = "https://github.com/python-jsonschema/referencing/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
