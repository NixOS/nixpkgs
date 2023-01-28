{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "justbackoff";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alexferl";
    repo = pname;
    rev = "v${version}";
    sha256 = "097j6jxgl4b3z46x9y9z10643vnr9v831vhagrxzrq6nviil2z6l";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner>=5.2" ""
  '';

  pythonImportsCheck = [
    "justbackoff"
  ];

  meta = with lib; {
    description = "Simple backoff algorithm in Python";
    homepage = "https://github.com/alexferl/justbackoff";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
