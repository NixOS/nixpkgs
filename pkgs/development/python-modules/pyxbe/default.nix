{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyxbe";
  version = "1.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = "pyxbe";
    tag = "v${version}";
    hash = "sha256-iLzGGgizUbaEG1xrNq4WDaWrGtcaLwAYgn4NGYiSDBo=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  # Update location for run with pytest
  preCheck = ''
    substituteInPlace tests/test_load.py \
      --replace '"xbefiles"' '"tests/xbefiles"'
  '';

  pythonImportsCheck = [ "xbe" ];

  meta = {
    description = "Library to work with XBE files";
    homepage = "https://github.com/mborgerson/pyxbe";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
