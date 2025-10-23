{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pypng";
  version = "0.20231004.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "drj11";
    repo = "pypng";
    tag = "pypng-${version}";
    hash = "sha256-tTnsGCAmHexDWm/T5xpHpcBaQcBEqMfTFaoOAeC+pDs=";
  };

  build-system = [ setuptools ];

  patches = [
    # pngsuite is imported by code/test_png.py but is not defined in
    # setup.cfg, so it isn't built - this adds it to py_modules
    ./setup-cfg-pngsuite.patch
  ];

  # allow tests to use the binaries produced by this package
  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [
    "png"
    "pngsuite"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pure Python library for PNG image encoding/decoding";
    homepage = "https://gitlab.com/drj11/pypng";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
