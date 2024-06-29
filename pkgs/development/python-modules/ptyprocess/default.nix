{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  flit-core,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ptyprocess";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XF0KO0jO7gtISF4MJgN8Cs19KXZco/u1yzgx00dCMiA=";
  };

  patches = [
    # Remove after https://github.com/pexpect/ptyprocess/pull/64 is merged.
    (fetchpatch {
      url = "https://github.com/pexpect/ptyprocess/commit/40c1ccf3432a6787be1801ced721540e34c6cd87.patch";
      hash = "sha256-IemngBqBq3QRCmVscWtsuXHiFgvTOJIIB9SyAvsqHd0=";
    })
  ];

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ptyprocess" ];

  meta = {
    description = "Run a subprocess in a pseudo terminal";
    homepage = "https://github.com/pexpect/ptyprocess";
    changelog = "https://github.com/pexpect/ptyprocess/releases/tag/${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
