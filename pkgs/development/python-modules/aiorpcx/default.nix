{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, attrs
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.23.1";
  pypoject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "aiorpcX";
    hash = "sha256-WyMALxpNXTCF4xVVoHUZxe+NTEAHHrSZVW/9qBFIYKI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    attrs
  ];

  passthru.optional-dependencies = {
    ws = [
      websockets
    ];
  };

  # Checks needs internet access
  doCheck = false;

  pythonImportsCheck = [
    "aiorpcx"
  ];

  meta = with lib; {
    description = "Transport, protocol and framing-independent async RPC client and server implementation";
    homepage = "https://github.com/kyuupichan/aiorpcX";
    changelog = "https://github.com/kyuupichan/aiorpcX/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
