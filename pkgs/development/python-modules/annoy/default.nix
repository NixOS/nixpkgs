{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  h5py,
  numpy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "annoy";
  version = "1.17.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "spotify";
    repo = "annoy";
    rev = "refs/tags/v${version}";
    hash = "sha256-oJHW4lULRun2in35pBGOKg44s5kgLH2BKiMOzVu4rf4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'nose>=1.0'" ""
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [ h5py ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf annoy
  '';

  disabledTestPaths = [
    # network access
    "test/accuracy_test.py"
  ];

  pythonImportsCheck = [ "annoy" ];

  meta = with lib; {
    description = "Approximate Nearest Neighbors in C++/Python optimized for memory usage and loading/saving to disk";
    homepage = "https://github.com/spotify/annoy";
    changelog = "https://github.com/spotify/annoy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
