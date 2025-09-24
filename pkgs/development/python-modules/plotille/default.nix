{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  setuptools,
  mock,
  pendulum,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "plotille";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tammoippen";
    repo = "plotille";
    tag = "v${version}";
    hash = "sha256-P2qwd935aaYgwLAKpTA2OAuohxVVzKwzYqjsuPSOSHs=";
  };

  patches = [
    # To remove when PR https://github.com/tammoippen/plotille/pull/63 has landed
    (fetchpatch {
      name = "add-build-information";
      url = "https://github.com/tammoippen/plotille/commit/db744e1fa9c141290966476ddf22a5e7d9a00c0a.patch";
      hash = "sha256-8vBVKrcH7R1d9ol3D7RLVtAzZbpMsB9rA1KHD7t3Ydc=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail poetry.masonry.api poetry.core.masonry.api \
      --replace-fail "poetry>=" "poetry-core>="
  '';

  build-system = [
    poetry-core
    setuptools
  ];

  pythonImportsCheck = [
    "plotille"
  ];

  nativeCheckInputs = [
    mock
    pendulum
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  meta = {
    changelog = "https://github.com/tammoippen/plotille/releases/tag/v${version}";
    description = "Plot in the terminal using braille dots";
    homepage = "https://github.com/tammoippen/plotille";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
