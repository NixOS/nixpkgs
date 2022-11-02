{ lib
, aesara
, buildPythonPackage
, fetchFromGitHub
, numdifftools
, numpy
, pytestCheckHook
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "aeppl";
  version = "0.0.38";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aesara-devs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-B9ZZEzGW4i0RRUaTAYiQ7+7pe4ArpSGcp/x4B6G7EYo=";
  };

  propagatedBuildInputs = [
    aesara
    numpy
    scipy
  ];

  checkInputs = [
    numdifftools
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "aeppl"
  ];

  disabledTests = [
    # Compute issue
    "test_initial_values"
  ];

  meta = with lib; {
    description = "Library for an Aesara-based PPL";
    homepage = "https://github.com/aesara-devs/aeppl";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
