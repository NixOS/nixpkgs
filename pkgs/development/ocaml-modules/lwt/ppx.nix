{ fetchzip, buildDunePackage, lwt, ppxlib }:

buildDunePackage {
  pname = "lwt_ppx";
  version = "2.0.2";

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchzip {
    # `lwt_ppx` has a different release cycle than Lwt, but it's included in
    # one of its release bundles.
    # Because there could exist an Lwt release _without_ a `lwt_ppx` release,
    # this `src` field doesn't inherit from the Lwt derivation.
    #
    # This is particularly useful for overriding Lwt without breaking `lwt_ppx`,
    # as new Lwt releases may contain broken `lwt_ppx` code.
    url = "https://github.com/ocsigen/lwt/archive/5.4.0.tar.gz";
    sha256 = "1ay1zgadnw19r9hl2awfjr22n37l7rzxd9v73pjbahavwm2ay65d";
  };

  propagatedBuildInputs = [ lwt ppxlib ];

  meta = {
    description = "Ppx syntax extension for Lwt";
    inherit (lwt.meta) license homepage maintainers;
  };
}
