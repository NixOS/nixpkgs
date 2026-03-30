{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mpmath,
  numpy,
  pybind11,
  pyfma,
  eigen,
  pytestCheckHook,
  matplotlib,
  dufte,
  perfplot,
}:

buildPythonPackage rec {
  pname = "accupy";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "accupy";
    rev = version;
    hash = "sha256-xxwLmL/rFgDFQNr8mRBFG1/NArQk9wanelL4Lu7ls2s=";
  };

  build-system = [
    setuptools
    pybind11
  ];

  buildInputs = [ eigen ];

  dependencies = [
    mpmath
    numpy
    pyfma
  ];

  nativeCheckInputs = [
    perfplot
    pytestCheckHook
    matplotlib
    dufte
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace-fail "/usr/include/eigen3/" "${eigen}/include/eigen3/"
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  # This variable is needed to suppress the "Trace/BPT trap: 5" error in Darwin's checkPhase.
  # Not sure of the details, but we can avoid it by changing the matplotlib backend during testing.
  env.MPLBACKEND = lib.optionalString stdenv.hostPlatform.isDarwin "Agg";

  # performance tests aren't useful to us and disabling them allows us to
  # decouple ourselves from an unnecessary build dep
  preCheck = ''
    for f in test/test*.py ; do
      substituteInPlace $f --replace-quiet 'import perfplot' ""
    done
  '';

  disabledTests = [
    "test_speed_comparison1"
    "test_speed_comparison2"
  ];

  pythonImportsCheck = [ "accupy" ];

  meta = {
    description = "Accurate sums and dot products for Python";
    homepage = "https://github.com/nschloe/accupy";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
