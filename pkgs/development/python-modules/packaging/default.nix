{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  flit-core,

  # tests
  packaging,
  pretend,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "packaging";
  version = "26.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-lO3CVkJK84di6zEwbu0ovrnw78UKiDdJLJ1v1gBK7Xk=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pretend
  ];

  pythonImportsCheck = [
    "packaging"
    "packaging.metadata"
    "packaging.requirements"
    "packaging.specifiers"
    "packaging.tags"
    "packaging.version"
  ];

  # Prevent circular dependency with pytest
  doCheck = false;

  passthru.tests = packaging.overridePythonAttrs (_: {
    doCheck = true;
  });

  meta = {
    changelog = "https://github.com/pypa/packaging/blob/${finalAttrs.version}/CHANGELOG.rst";
    description = "Core utilities for Python packages";
    downloadPage = "https://github.com/pypa/packaging";
    homepage = "https://packaging.pypa.io/";
    license = with lib.licenses; [
      bsd2
      asl20
    ];
    maintainers = with lib.maintainers; [ bennofs ];
    teams = [ lib.teams.python ];
  };
})
