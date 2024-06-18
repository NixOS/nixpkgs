{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  pythonOlder,
  backports-zoneinfo,
  python-dateutil,
  setuptools,
  tzdata,
  hypothesis,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "pytz-deprecation-shim";
  version = "0.1.0.post0";

  format = "pyproject";

  src = fetchPypi {
    pname = "pytz_deprecation_shim";
    inherit version;
    sha256 = "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs =
    (lib.optionals (pythonAtLeast "3.6" && pythonOlder "3.9") [ backports-zoneinfo ])
    ++ (lib.optionals (pythonOlder "3.6") [ python-dateutil ])
    ++ (lib.optionals (pythonAtLeast "3.6") [ tzdata ]);

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytz
  ];

  # https://github.com/pganssle/pytz-deprecation-shim/issues/27
  # https://github.com/pganssle/pytz-deprecation-shim/issues/30
  # The test suite is just very flaky and breaks all the time
  doCheck = false;

  meta = with lib; {
    description = "Shims to make deprecation of pytz easier";
    homepage = "https://github.com/pganssle/pytz-deprecation-shim";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
