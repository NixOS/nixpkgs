{ mkXfceDerivation, gtk2, libX11 }:

mkXfceDerivation rec {
  category = "apps";
  pname = "gigolo";
  version = "0.4.2";

  sha256 = "0qd2jkf3zsvfyd9jn8bfnljja1xfj3ph4wjh3fx10dcwcd791al1";

  buildInputs = [ gtk2 libX11 ];
}
