{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, APScheduler
, hiredis
, aioredis
, ephem
, pytz
, pyyaml
}:

buildPythonPackage rec {
  pname = "automate-home";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-41qd+KPSrOrczkovwXht3irbcYlYehBZ1HZ44yZe4cM=";
  };

  propagatedBuildInputs = [
    APScheduler
    hiredis
    aioredis
    ephem
    pytz
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # Rename pyephem, https://github.com/majamassarini/automate-home/pull/3
    substituteInPlace setup.py \
      --replace "pyephem" "ephem" \
      --replace "aioredis==1.3.1" "aioredis"
  '';

  pythonImportsCheck = [
    "home"
  ];

  meta = with lib; {
    description = "Python module to automate (home) devices";
    homepage = "https://github.com/majamassarini/automate-home";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
