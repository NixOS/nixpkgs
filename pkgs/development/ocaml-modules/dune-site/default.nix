{ lib, buildDunePackage, dune_2, dune-private-libs }:

buildDunePackage rec {
  pname = "dune-site";
  inherit (dune_2) src version patches;

  dontAddPrefix = true;

  propagatedBuildInputs = [ dune-private-libs ];

  meta = with lib; {
    description = "A library for embedding location information inside executable and libraries";
    inherit (dune_2.meta) homepage;
    maintainers = with lib.maintainers; [ ];
    license = licenses.mit;
  };
}
