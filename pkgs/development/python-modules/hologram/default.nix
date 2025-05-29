{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  jsonschema,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "hologram";
  version = "0.0.16";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "hologram";
    tag = "v${version}";
    hash = "sha256-DboVCvByI8bTThamGBwSiQADGxIaEnTMmwmVI+4ARgc=";
  };

  patches = [
    # https://github.com/dbt-labs/hologram/pull/58
    (fetchpatch {
      name = "python3.11-test-compatibility.patch";
      url = "https://github.com/dbt-labs/hologram/commit/84bbe862ef6a2fcc8b8ce85b5c9a006cc7dc1f66.patch";
      hash = "sha256-t096jJDoKUPED4QHSfVjUMLtUJjWcqjblCtGR8moEJc=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    jsonschema
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonRelaxDeps = [ "python-dateutil" ];

  pythonImportsCheck = [ "hologram" ];

  meta = with lib; {
    description = "Library for automatically generating Draft 7 JSON Schemas from Python dataclasses";
    homepage = "https://github.com/dbt-labs/hologram";
    license = licenses.mit;
    maintainers = with maintainers; [
      mausch
      tjni
    ];
  };
}
