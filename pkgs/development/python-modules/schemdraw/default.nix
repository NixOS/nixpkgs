{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pyparsing,
  matplotlib,
  latex2mathml,
  ziafont,
  ziamath,
  pytestCheckHook,
  nbval,
}:

buildPythonPackage rec {
  pname = "schemdraw";
  version = "0.19";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-vqEHcazE5DNHr0FceOWLqq+RZmMK5ovHDVjy/2wbTJU=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyparsing ];

  optional-dependencies = {
    matplotlib = [ matplotlib ];
    svgmath = [
      latex2mathml
      ziafont
      ziamath
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    nbval
    matplotlib
    latex2mathml
    ziafont
    ziamath
  ];

  # Strip out references to unfree fonts from the test suite
  postPatch = ''
    substituteInPlace test/test_styles.ipynb --replace "font='Times', " ""
  '';

  preCheck = "rm test/test_pictorial.ipynb"; # Tries to download files

  pytestFlagsArray = [ "--nbval-lax" ];

  pythonImportsCheck = [ "schemdraw" ];

  meta = with lib; {
    description = "A package for producing high-quality electrical circuit schematic diagrams";
    homepage = "https://schemdraw.readthedocs.io/en/latest/";
    changelog = "https://schemdraw.readthedocs.io/en/latest/changes.html";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
