{ lib, buildPythonPackage, isPy3k, fetchPypi, httpx }:

buildPythonPackage rec {
  pname = "luftdaten";
  version = "0.7.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-D1eMZ8lvqgW0u9DvzSR2wkoMu1aXUchbckhfTTAwH1I=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "httpx>=0.20.0,<0.21.0" "httpx"
  '';

  propagatedBuildInputs = [
    httpx
  ];

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [ "luftdaten" ];

  meta = with lib; {
    description = "Python API for interacting with luftdaten.info";
    homepage = "https://github.com/home-assistant-ecosystem/python-luftdaten";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
