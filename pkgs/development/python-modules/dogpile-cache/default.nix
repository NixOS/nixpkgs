{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytestCheckHook
, mako
, decorator
, stevedore
, typing-extensions
}:

buildPythonPackage rec {
  pname = "dogpile-cache";
  version = "1.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "dogpile.cache";
    inherit version;
    hash = "sha256-/ZAiwNnLra3yCUI5GpWtrylr6AtC2qjiAvjeHCHxmLI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    decorator
    stevedore
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mako
  ];

  meta = with lib; {
    description = "A caching front-end based on the Dogpile lock";
    homepage = "https://github.com/sqlalchemy/dogpile.cache";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
