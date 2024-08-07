{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  numpy,
  scipy,
  six,
  paramz,
  matplotlib,
  cython,
}:

buildPythonPackage rec {
  pname = "gpy";
  version = "1.13.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "SheffieldML";
    repo = "GPy";
    rev = "refs/tags/v${version}";
    hash = "sha256-kggXePDKJcgw8qwLIBTxbwhiLw2H4dkx7082FguKP0Y=";
  };

  pythonRelaxDeps = [
    "paramz"
    "scipy"
  ];

  nativeBuildInputs = [ setuptools ];
  buildInputs = [ cython ];
  propagatedBuildInputs = [
    numpy
    scipy
    six
    paramz
    matplotlib
  ];
  nativeCheckInputs = [ pytestCheckHook ];

  # Rebuild cython-generated .c files to ensure compatibility
  preBuild = ''
    for fn in $(find . -name '*.pyx'); do
      echo $fn | sed 's/\.\.pyx$/\.c/' | xargs ${cython}/bin/cython -3
    done
  '';

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Rounding difference break comparison
    "TestGradientMultiOutputGPModel"
  ];

  pythonImportsCheck = [ "GPy" ];

  meta = with lib; {
    description = "Gaussian process framework in Python";
    homepage = "https://sheffieldml.github.io/GPy";
    changelog = "https://github.com/SheffieldML/GPy/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
