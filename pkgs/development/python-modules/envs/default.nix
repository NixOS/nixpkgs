{ lib
, buildPythonPackage
, click
, fetchPypi
, jinja2
, mock
, nose
, poetry-core
, pythonOlder
, terminaltables
}:

buildPythonPackage rec {
  pname = "envs";
  version = "1.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nYQ1xphdHN1oKZ4ExY4r24rmz2ayWWqAeeb5qT8qA5g=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    jinja2
    terminaltables
  ];

  checkInputs = [
    mock
    nose
  ];

  checkPhase = ''
    runHook preCheck

    nosetests --with-isolation

    runHook postCheck
  '';

  pythonImportsCheck = [
    "envs"
  ];

  meta = with lib; {
    description = "Easy access to environment variables from Python";
    homepage = "https://github.com/capless/envs";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
