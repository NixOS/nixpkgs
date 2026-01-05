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
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "schemdraw";
  version = "0.21";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "cdelker";
    repo = "schemdraw";
    tag = version;
    hash = "sha256-+pvVt7Of5v17PNdZMj8hHvE5tICiTRMelp4trdUZsz4=";
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
    writableTmpDirAsHomeHook
  ];

  # Strip out references to unfree fonts from the test suite
  postPatch = ''
    substituteInPlace test/test_backend.ipynb --replace-fail "(font='Times')" "()"
  '';

  preCheck = "rm test/test_pictorial.ipynb"; # Tries to download files

  pytestFlags = [ "--nbval-lax" ];

  pythonImportsCheck = [ "schemdraw" ];

  meta = with lib; {
    description = "Package for producing high-quality electrical circuit schematic diagrams";
    homepage = "https://schemdraw.readthedocs.io/en/latest/";
    changelog = "https://schemdraw.readthedocs.io/en/latest/changes.html";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
