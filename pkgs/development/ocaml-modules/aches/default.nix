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

  meta = with lib; {
    description = "Caches (bounded-size stores) for in-memory values and for resources";
    license = licenses.mit;
    maintainers = [ maintainers.ulrikstrid ];
  };
}
