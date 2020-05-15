{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "0.9.18";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11mw14rd12alqd3p038wijlwmfv81gwd2w4viypcghkjia5y2r2x";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Minimalistic evaluator of python expression using ast module";
    homepage = "https://github.com/newville/asteval";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
