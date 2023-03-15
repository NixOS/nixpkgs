{ lib
, buildPythonPackage
, fetchPypi
, click
, twisted
}:

let incremental = buildPythonPackage rec {
  pname = "incremental";
  version = "22.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kS/uteD34BiOb0IkHS9FAALhG7wJN8ZYZQRYVMJMC9A=";
  };

  propagatedBuildInputs = [
    click
  ];

  # escape infinite recursion with twisted
  doCheck = false;

  nativeCheckInputs = [
    twisted
  ];

  checkPhase = ''
    trial incremental
  '';

  passthru.tests = {
    check = incremental.overridePythonAttrs (_: { doCheck = true; });
  };

  pythonImportsCheck = [ "incremental" ];

  meta = with lib; {
    homepage = "https://github.com/twisted/incremental";
    description = "Incremental is a small library that versions your Python projects";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}; in incremental
