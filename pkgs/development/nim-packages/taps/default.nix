{ lib, buildNimPackage, fetchFromSourcehut, getdns }:

buildNimPackage rec {
  pname = "taps";
  version = "20230331";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_${pname}";
    rev = version;
    hash = "sha256-p2DBJWFwS82oHPq0uMCtZWFbn8GFndEJBjhkHeuPGos=";
  };
  propagatedBuildInputs = [ getdns ];
  doCheck = false;
  meta = src.meta // {
    description = "Transport Services Interface";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ehmry ];
  };
}
