{
  lib,
  python,
  fetchPypi,
}:

python.pkgs.buildPythonPackage rec {
  pname = "peeringdb";
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-CsK7CyV1K0Av6pNeHgOnn4fHJylEeZZbynBaw48Y31o=";
  };

  build-system = [
    python.pkgs.hatchling
  ];

  dependencies = with python.pkgs; [
    confu
    httpx
    munge
    pyyaml
    twentyc-rpc
    django
    django-countries
    django-peeringdb
  ];

  pythonImportsCheck = [
    "peeringdb"
  ];

  meta = {
    description = "PeeringDB Django models";
    homepage = "https://pypi.org/project/peeringdb/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "peeringdb";
  };
}
