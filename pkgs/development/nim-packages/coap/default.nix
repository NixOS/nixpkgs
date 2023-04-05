{ lib, buildNimPackage, fetchFromGitea, taps }:

buildNimPackage rec {
  pname = "coap";
  version = "20230125";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
    repo = "${pname}-nim";
    rev = version;
    hash = "sha256-wlDyqRxXTrX+zXDIe2o9FTU2o26LO/6m7H/FGok1JDw=";
  };
  propagatedBuildInputs = [ taps ];
  meta = src.meta // {
    description =
      "Nim implementation of the Constrained Application Protocol (CoAP) over TCP";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
