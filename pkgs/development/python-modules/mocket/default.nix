{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy27
, decorator
, http-parser
, importlib-metadata
, python
, python_magic
, six
, urllib3 }:

buildPythonPackage rec {
  pname = "mocket";
  version = "3.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15npwf0f8g5vmwpmyvmsyi4p9ia1w95z8jips0nkfs978pnjy69g";
  };

  patchPhase = ''
    sed -iE "s,python-magic==.*,python-magic," requirements.txt
    sed -iE "s,urllib3==.*,urllib3," requirements.txt
    substituteInPlace setup.py --replace 'setup_requires=["pipenv"]' "setup_requires=[]"
  '';

  propagatedBuildInputs = [
    decorator
    http-parser
    python_magic
    urllib3
    six
  ] ++ lib.optionals (isPy27) [ six ];

  # Pypi has no runtests.py, github has no requirements.txt. No way to test, no way to install.
  doCheck = false;

  pythonImportsCheck = [ "mocket" ];

  meta = with lib; {
    description = "A socket mock framework - for all kinds of socket animals, web-clients included";
    homepage = "https://github.com/mindflayer/python-mocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
