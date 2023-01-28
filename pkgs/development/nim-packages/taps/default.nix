{ lib, buildNimPackage, fetchFromSourcehut, getdns }:

buildNimPackage rec {
  pname = "taps";
  version = "20221228";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_${pname}";
    rev = version;
    hash = "sha256-0EjMP5pIPJg4/3nzj6ECC68f709TS06OrJlTZ0tavEo=";
  };
  propagatedBuildInputs = [ getdns ];
  doCheck = false;
  meta = src.meta // {
    description = "Transport Services Interface";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ehmry ];
  };
}
