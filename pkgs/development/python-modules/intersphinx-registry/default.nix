{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # optional-dependencies
  platformdirs,
  requests,
  requests-cache,
  sphinx,
  mypy,
  pytest,
  pytest-xdist,
  types-requests,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "intersphinx-registry";
  version = "0.2705.27";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Quansight-labs";
    repo = "intersphinx_registry";
    tag = finalAttrs.version;
    hash = "sha256-yFpk3NZO2iCjuJ43WvssbDYxNJ6G6KfY5pcTCilsGQs=";
  };

  build-system = [
    flit-core
  ];

  dependencies = finalAttrs.passthru.optional-dependencies.lookup;

  optional-dependencies = {
    lookup = [
      platformdirs
      requests
      requests-cache
      sphinx
    ];
    tests = [
      mypy
      pytest
      pytest-xdist
      types-requests
    ];
  };

  nativeCheckInputs = [
    mypy
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.tests;

  # TODO: lots of failing tests
  doCheck = false;

  pythonImportsCheck = [
    "intersphinx_registry"
  ];

  meta = {
    description = "Utility package that provides a default intersphinx mapping";
    homepage = "https://github.com/Quansight-labs/intersphinx_registry";
    mainProgram = "intersphinx-registry";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
