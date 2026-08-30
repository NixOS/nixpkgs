{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "justbackoff";
  version = "0.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alexferl";
    repo = "justbackoff";
    rev = "v${version}";
    hash = "sha256-1HxBY9zW4Px7fgruMNBO2e5BDAg/+dQN+WMR+ro08iQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner>=5.2" ""
  '';

  pythonImportsCheck = [ "justbackoff" ];

  meta = {
    description = "Simple backoff algorithm in Python";
    homepage = "https://github.com/alexferl/justbackoff";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
