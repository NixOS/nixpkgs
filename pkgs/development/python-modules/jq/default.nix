{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, fetchpatch
, jq
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jq";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "jq.py";
    rev = "refs/tags/${version}";
    hash = "sha256-mITk5y2AdUc9kZ/WrsnHxS1GRRmO4FDbPRgTtV2gIXI=";
  };

  patches = [
    # Removes vendoring
    ./jq-py-setup.patch
    (fetchpatch {
      url = "https://github.com/mwilliamson/jq.py/commit/805705dde4beb9db9a1743663d415198fb02eb1a.patch";
      includes = [ "tests/*" ];
      hash = "sha256-AgdpwmtOTeJ4nSbM6IknKaIVqqtWkpxTTtblXjlbWeA=";
    })
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
