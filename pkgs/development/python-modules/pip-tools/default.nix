{ lib
, fetchPypi
, pythonOlder
, buildPythonPackage
, pip
, pytestCheckHook
, pytest-xdist
, click
, setuptools-scm
, pep517
, stdenv
}:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "6.6.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9jhQOp932Y2afXJYSxUI0/gu0Bm4+rJPTlrQeMG4yV4=";
  };

  checkInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  preCheck = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
    pep517
    pip
  ];

  disabledTests = [
    # these want internet access
    "network"
    "test_direct_reference_with_extras"
  ];

  meta = with lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = "https://github.com/jazzband/pip-tools/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
