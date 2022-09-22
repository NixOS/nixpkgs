{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, hatchling
}:

buildPythonPackage rec {
  pname = "hatch-nodejs-version";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "hatch_nodejs_version";
    inherit version;
    sha256 = "sha256-fgi9Z/zT2/uXyvj2KaIXPksRdHXuUZZvBaIWmqrQYJc=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    hatchling
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hatch_nodejs_version"
  ];

  meta = with lib; {
    description = "Hatch plugin to read pyproject.toml metadata from package.json";
    homepage = "https://github.com/agoose77/hatch-nodejs-version";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
