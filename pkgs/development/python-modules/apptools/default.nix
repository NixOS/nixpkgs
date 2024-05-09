{ lib
, buildPythonPackage
, configobj
, fetchPypi
, importlib-resources
, pandas
, pytestCheckHook
, pythonOlder
, tables
, traits
, traitsui
}:

buildPythonPackage rec {
  pname = "apptools";
  version = "5.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xiaPXfzzCIvK92oAA+ULd3TQG1JY1xmbQQtIUv8iRuM=";
  };

  propagatedBuildInputs = [
    configobj
    traits
    traitsui
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [
    tables
    pandas
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMP
  '';

  pythonImportsCheck = [
    "apptools"
  ];

  meta = with lib; {
    description = "Set of packages that Enthought has found useful in creating a number of applications";
    homepage = "https://github.com/enthought/apptools";
    changelog = "https://github.com/enthought/apptools/releases/tag/${version}";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
