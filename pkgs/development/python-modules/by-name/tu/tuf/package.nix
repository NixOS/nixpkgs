{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,
  hatchling,

  # dependencies
  requests,
  securesystemslib,

  # tests
  ed25519,
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tuf";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theupdateframework";
    repo = "python-tuf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CPbZOpUYi7MWKLMj7kwTsmEkxLCf4wU7IOCcbzMkPlU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.27.0" "hatchling"
  '';

  build-system = [
    flit-core
    hatchling
  ];

  dependencies = [
    requests
    securesystemslib
  ]
  ++ securesystemslib.optional-dependencies.pynacl
  ++ securesystemslib.optional-dependencies.crypto;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    ed25519
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tuf" ];

  preCheck = ''
    cd tests
  '';

  meta = {
    description = "Python reference implementation of The Update Framework (TUF)";
    homepage = "https://github.com/theupdateframework/python-tuf";
    changelog = "https://github.com/theupdateframework/python-tuf/blob/${finalAttrs.src.tag}/docs/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
