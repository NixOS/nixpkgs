{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  unittestCheckHook,
  cargo,
  rustc,
  rustPlatform,
  semver,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiotarfile";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhelmot";
    repo = "aiotarfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V88cvVw6ss7iiojhlqDd2frG/gCEH0YKTP0IpgeFASw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Yf6N615X9ZB+HDp3xehMc3kjKbdsSbIJrqARRXwCRDQ=";
  };

  postPatch = ''
    patchShebangs release.py
    ./release.py finalize
  '';

  build-system = [
    semver # required for release.py
  ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [ "--start-directory=tests" ]; # Not sure why it isn't autodiscovered

  # pyo3-asyncio 0.20 segfaults on the python 3.14 interpreter state.
  doCheck = pythonOlder "3.14";

  pythonImportsCheck = [ "aiotarfile" ];

  meta = {
    description = "Stream-based, asynchronous tarball processing";
    homepage = "https://github.com/rhelmot/aiotarfile";
    changelog = "https://github.com/rhelmot/aiotarfile/commits/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicoo ];
  };
})
