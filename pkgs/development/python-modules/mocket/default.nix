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
  version = "3.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bp6642qh8fkjqgvp1vif2zbzpappbbq3sgs7vfr87inn4frc2cz";
  };

  patchPhase = ''
    substituteInPlace requirements.txt \
      --replace "python-magic==0.4.18" "python-magic" \
      --replace "urllib3==1.25.10" "urllib3"
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
