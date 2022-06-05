{ lib
, stdenv
, buildPythonPackage
, click
, fetchPypi
, pep517
, pip
, pytest-xdist
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "6.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9jhQOp932Y2afXJYSxUI0/gu0Bm4+rJPTlrQeMG4yV4=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
    pep517
    pip
    setuptools
    wheel
  ];

  checkInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '';

  disabledTests = [
    # Tests require network access
    "network"
    "test_direct_reference_with_extras"
  ];

  pythonImportsCheck = [
    "piptools"
  ];

  meta = with lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = "https://github.com/jazzband/pip-tools/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
