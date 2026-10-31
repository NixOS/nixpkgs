{
  lib,
  buildDunePackage,
  ringo,
}:

buildDunePackage {
  pname = "aches";
  inherit (ringo) src version;

  propagatedBuildInputs = [
    ringo
  ];

  meta = {
    description = "Caches (bounded-size stores) for in-memory values and for resources";
    homepage = "https://gitlab.com/nomadic-labs/ringo";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
