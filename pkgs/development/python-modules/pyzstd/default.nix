{
  buildPythonPackage,
  fetchPypi,
  lib,
  nix-update-script,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyzstd";
  version = "0.16.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F5waLqFWWr8JxfL9cvnOfFSydkz3Np4FwL/Y8fZ/Y9I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=64,<74" "setuptools>=64"
  '';

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/Rogdham/pyzstd";
    description = "Python bindings to Zstandard (zstd) compression library";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jwillikers ];
  };
}
