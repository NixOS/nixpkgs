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
    sha256 = "097j6jxgl4b3z46x9y9z10643vnr9v831vhagrxzrq6nviil2z6l";
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
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
