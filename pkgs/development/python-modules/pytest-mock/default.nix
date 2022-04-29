{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pytest
, pytest-asyncio
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-URK9ksyfGG7pbhqS78hJaepJSTnDrq05xQ9CHEzGlTQ=";
  };

  patches = [
    (fetchpatch {
      # pytest7 compatbilitya
      url = "https://github.com/pytest-dev/pytest-mock/commit/0577f1ad051fb8d0da94ea22dcb02346d74064b2.patch";
      hash = "sha256-eim4v7U8Mjigr462bXI0pKH/M0ANBzSRc0lT4RpbZ0w=";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    pytest
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # output of pytest has changed
    "test_used_with_"
    "test_plain_stopall"
  ];

  pythonImportsCheck = [ "pytest_mock" ];

  meta = with lib; {
    description = "Thin-wrapper around the mock package for easier use with pytest";
    homepage = "https://github.com/pytest-dev/pytest-mock";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
