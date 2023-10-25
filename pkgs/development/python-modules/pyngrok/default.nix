{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
}:

buildPythonPackage rec {
  pname = "pyngrok";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3YqHlEuOKFcuPRJr+yyBopSFlFdfUjfu/TZRrgtIcVU=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  pythonImportsCheck = [ "pyngrok" ];

  meta = with lib; {
    homepage = "https://github.com/alexdlaird/pyngrok";
    description = "A Python wrapper for ngrok";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
