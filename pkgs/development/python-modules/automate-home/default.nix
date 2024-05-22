{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  apscheduler,
  hiredis,
  aioredis,
  ephem,
  setuptools,
  pytz,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "automate-home";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-41qd+KPSrOrczkovwXht3irbcYlYehBZ1HZ44yZe4cM=";
  };

  postPatch = ''
    # Rename pyephem, https://github.com/majamassarini/automate-home/pull/3
    substituteInPlace setup.py \
      --replace-fail "pyephem" "ephem" \
      --replace-fail "aioredis==1.3.1" "aioredis"
  '';

  build-system = [ setuptools ];

  dependencies = [
    apscheduler
    hiredis
    aioredis
    ephem
    pytz
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "home" ];

  meta = with lib; {
    description = "Python module to automate (home) devices";
    homepage = "https://github.com/majamassarini/automate-home";
    changelog = "https://github.com/majamassarini/automate-home/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
