{ lib
, isPyPy
, buildPythonPackage
, fetchPypi

# build
, pytest

# runtime
, setuptools-git
, mock
, path
, execnet
, contextlib2
, termcolor
, six

# tests
, cmdline
, pytestCheckHook
 }:

buildPythonPackage rec {
  pname = "pytest-shutil";
  version = "1.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2BZSYd5251CFBcNB2UwCsRPclj8nRUOrynTb+r0CEmE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "path.py" "path"
  '';

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    setuptools-git
    mock
    path
    execnet
    contextlib2
    termcolor
    six
  ];

  checkInputs = [
    cmdline
    pytestCheckHook
  ];

  disabledTests = [
    "test_pretty_formatter"
  ] ++ lib.optionals isPyPy [
    "test_run"
    "test_run_integration"
  ];

  meta = with lib; {
    description = "A goodie-bag of unix shell and environment tools for py.test";
    homepage = "https://github.com/manahl/pytest-plugins";
    maintainers = with maintainers; [ ryansydnor ];
    license = licenses.mit;
  };
}
