{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Marco-Sulla";
    repo = "python-frozendict";
    rev = "refs/tags/v${version}";
    hash = "sha256-IlKhqQvNaYz4+U8UJ/fGUNNTC3RjyGKCJUzJ6J431Vw=";
  };

  postPatch = ''
    # https://github.com/Marco-Sulla/python-frozendict/pull/69
    substituteInPlace setup.py \
      --replace 'if impl == "PyPy":' 'if impl == "PyPy" or not src_path.exists():'
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "frozendict"
  ];

  preCheck = ''
    pushd test
  '';

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/Marco-Sulla/python-frozendict/issues/68
    "test_c_extension"
  ];

  meta = with lib; {
    description = "Module for immutable dictionary";
    homepage = "https://github.com/Marco-Sulla/python-frozendict";
    changelog = "https://github.com/Marco-Sulla/python-frozendict/releases/tag/v${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ ];
  };
}
