{ lib, fetchPypi, buildPythonPackage
, configobj, six, traitsui
, pytestCheckHook, tables, pandas
, pythonOlder, importlib-resources
}:

buildPythonPackage rec {
  pname = "apptools";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12x5lcs1cllpybz7f0i1lcwvmqsaa5n818wb2165lj049wqxx4yh";
  };

  propagatedBuildInputs = [
    configobj
    six
    traitsui
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  checkInputs = [
    tables
    pandas
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMP
  '';

  meta = with lib; {
    description = "Set of packages that Enthought has found useful in creating a number of applications.";
    homepage = "https://github.com/enthought/apptools";
    maintainers = with maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
