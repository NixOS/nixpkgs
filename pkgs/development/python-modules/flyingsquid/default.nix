{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pgmpy,
  torch,
}:
let
  pname = "flyingsquid";
  version = "0.0.0a0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "HazyResearch";
    repo = "flyingsquid";
    rev = "28a713a9ac501b7597c2489468ae189943d00685";
    hash = "sha256-DPHTSxDD4EW3nrNk2fk0pKJI/8+pQ7Awywd8nxhBruo=";
  };

  propagatedBuildInputs = [
    pgmpy
    torch
  ];

  pythonImportsCheck = [ "flyingsquid" ];

  # no tests
  doCheck = false;

  meta = {
    description = "More interactive weak supervision with FlyingSquid";
    homepage = "https://github.com/HazyResearch/flyingsquid";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
