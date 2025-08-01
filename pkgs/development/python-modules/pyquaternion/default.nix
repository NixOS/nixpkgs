{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyquaternion";
  version = "0.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KieranWynn";
    repo = "pyquaternion";
    rev = "v${version}";
    hash = "sha256-L0wT9DFUDRcmmN7OpmIDNvtQWQrM7iFnZt6R2xrJ+3A=";
  };

  patches = [
    ./numpy2-repr.patch
  ];

  # The VERSION.txt file is required for setup.py
  # See: https://github.com/KieranWynn/pyquaternion/blob/master/setup.py#L14-L15
  postPatch = ''
    echo "${version}" > VERSION.txt
  '';

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "pyquaternion/test/" ];

  pythonImportsCheck = [ "pyquaternion" ];

  meta = with lib; {
    description = "Library for representing and using quaternions";
    homepage = "http://kieranwynn.github.io/pyquaternion/";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
