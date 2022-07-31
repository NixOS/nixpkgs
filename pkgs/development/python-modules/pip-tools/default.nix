{ lib
, stdenv
, buildPythonPackage
, build
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
  version = "6.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oeiu5GVEbgInjYDb69QyXR3YYzJI9DITxzol9Y59ilU=";
  };

  patches = [ ./fix-setup-py-bad-syntax-detection.patch ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    build
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
    "test_local_duplicate_subdependency_combined"
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
