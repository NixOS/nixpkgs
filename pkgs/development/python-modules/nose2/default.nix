{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools

# optional-dependencies
, coverage

# tests
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "nose2";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XCjXcKC5pwKGK9bDdVuizS95lN1RjJguXOKY1/N0ZqQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  passthru.optional-dependencies = {
    coverage = [
      coverage
    ];
  };

  pythonImportsCheck = [
    "nose2"
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    unittestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  preCheck = ''
    # https://github.com/nose-devs/nose2/issues/588
    substituteInPlace nose2/tests/functional/test_junitxml_plugin.py \
      --replace "test_skip_reason_in_message" "dont_test_skip_reason_in_message"
  '';

  meta = with lib; {
    description = "Test runner for Python";
    homepage = "https://github.com/nose-devs/nose2";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
