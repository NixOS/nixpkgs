{ lib
, fetchPypi
, buildPythonPackage
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "latex2pydata";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ega1cHSP187njyelb0yiCdpk08QZyObelRa2S79AE1E=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/gpoore/latex2pydata";
    description = "Send data from LaTeX to Python using Python literal format";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
