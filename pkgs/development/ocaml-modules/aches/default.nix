{ lib, buildDunePackage, ringo }:

buildDunePackage {
  pname = "aches";
  inherit (ringo) src version;

  propagatedBuildInputs = [
    ringo
  ];

  meta = {
    description = "Caches (bounded-size stores) for in-memory values and for resources";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
