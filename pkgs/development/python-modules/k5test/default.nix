{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, substituteAll
, findutils
, krb5
, setuptools
}:

buildPythonPackage rec {
  pname = "k5test";
  version = "0.10.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4VJJHmYC9qk7PVM9OHvUWQ8kdgk7aEIXD/C5PeZL7zA=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit findutils krb5;
      # krb5-config is in dev output
      krb5Dev = krb5.dev;
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "k5test"
  ];

  meta = with lib; {
    description = "Library for setting up self-contained Kerberos 5 environment";
    homepage = "https://github.com/pythongssapi/k5test";
    changelog = "https://github.com/pythongssapi/k5test/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    broken = stdenv.isDarwin;
  };
}
