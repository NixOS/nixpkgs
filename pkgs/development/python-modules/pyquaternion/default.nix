{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyquaternion";
  version = "0.9.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "KieranWynn";
    repo = "pyquaternion";
    rev = "v${version}";
    hash = "sha256-L0wT9DFUDRcmmN7OpmIDNvtQWQrM7iFnZt6R2xrJ+3A=";
  };

  # The VERSION.txt file is required for setup.py
  # See: https://github.com/KieranWynn/pyquaternion/blob/master/setup.py#L14-L15
  postPatch = ''
    echo "${version}" > VERSION.txt
  '';

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "pyquaternion/test/" ];

  pythonImportsCheck = [ "pyquaternion" ];

  meta = with lib; {
    description = "Library for representing and using quaternions";
    homepage = "http://kieranwynn.github.io/pyquaternion/";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
