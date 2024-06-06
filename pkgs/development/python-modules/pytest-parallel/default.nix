{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # build inputs
  tblib,
  pytest,
  py,
}:
let
  pname = "pytest-parallel";
  version = "0.1.1";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "kevlened";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ddpoWBTf7Zor569p6uOMjHSTx3Qa551f4mSwyTLDdBU=";
  };

  propagatedBuildInputs = [
    tblib
    pytest
    py
  ];

  meta = with lib; {
    description = "A pytest plugin for parallel and concurrent testing";
    homepage = "https://github.com/kevlened/pytest-parallelt";
    changelog = "https://github.com/kevlened/pytest-parallel/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
