{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, jq
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jq";
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "jq.py";
    rev = "refs/tags/${version}";
    hash = "sha256-prH3yUFh3swXGsxnoax09aYAXaiu8o2M21ZbOp9HDJY=";
  };

  patches = [
    # Removes vendoring
    ./jq-py-setup.patch
  ];

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    jq
  ];

  preBuild = ''
    cython jq.pyx
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jq"
  ];

  meta = with lib; {
    description = "Python bindings for jq, the flexible JSON processor";
    homepage = "https://github.com/mwilliamson/jq.py";
    changelog = "https://github.com/mwilliamson/jq.py/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ benley ];
  };
}
