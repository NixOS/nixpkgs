{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "decli";
  version = "0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7YjMuUdwHo5VCbeUX9pW4VDirHSmnyXUeshe8wqwwPA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "decli"
  ];

  meta = with lib; {
    description = "Minimal, easy to use, declarative command line interface tool";
    homepage = "https://github.com/Woile/decli";
    changelog = "https://github.com/woile/decli/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
