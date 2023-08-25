{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
, mock
, brotli
}:

buildPythonPackage rec {
  pname = "logbook";
  version = "1.5.3";

  src = fetchPypi {
    pname = "Logbook";
    inherit version;
    sha256 = "1s1gyfw621vid7qqvhddq6c3z2895ci4lq3g0r1swvpml2nm9x36";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.optionals (!isPy3k) [
    mock
  ];

  propagatedBuildInputs = [
    brotli
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "logbook"
  ];

  meta = with lib; {
    description = "A logging replacement for Python";
    homepage = "https://logbook.readthedocs.io/";
    changelog = "https://github.com/getlogbook/logbook/blob/${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
