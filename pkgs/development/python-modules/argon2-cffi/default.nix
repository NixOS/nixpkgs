{
  hypothesis,
  pytestCheckHook,
  buildPythonPackage,
  fetchPypi,
  lib,
  hatchling,
  hatch-vcs,
  hatch-fancy-pypi-readme,
  argon2-cffi-bindings,
}:

buildPythonPackage rec {
  pname = "argon2-cffi";
  version = "25.1.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "argon2_cffi";
    inherit version;
    hash = "sha256-aUrlzIpC9MTivyyg5k5R4joEDGpReoUHRoPTlZ4TRsE=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [ argon2-cffi-bindings ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "argon2" ];

  meta = with lib; {
    description = "Secure Password Hashes for Python";
    homepage = "https://argon2-cffi.readthedocs.io/";
    license = licenses.mit;
  };
}
