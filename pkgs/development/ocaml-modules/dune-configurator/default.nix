{ lib, buildDunePackage, dune_2, dune-private-libs }:

buildDunePackage rec {
  pname = "dune-configurator";

  inherit (dune_2) src version;

  dontAddPrefix = true;

  propagatedBuildInputs = [ dune-private-libs ];

  meta = with lib; {
    description = "Helper library for gathering system configuration";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
