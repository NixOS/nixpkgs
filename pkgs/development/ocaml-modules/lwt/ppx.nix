{ fetchFromGitHub, buildDunePackage, lwt, ppxlib }:

buildDunePackage {
  pname = "lwt_ppx";
  version = "2.1.0";
  duneVersion = "3";

  minimalOCamlVersion = "4.04";

  # `lwt_ppx` has a different release cycle than Lwt, but it's included in
  # one of its release bundles.
  # Because there could exist an Lwt release _without_ a `lwt_ppx` release,
  # this `src` field doesn't inherit from the Lwt derivation.
  #
  # This is particularly useful for overriding Lwt without breaking `lwt_ppx`,
  # as new Lwt releases may contain broken `lwt_ppx` code.
  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "lwt";
    rev = "5.6.0";
    hash = "sha256-DLQupCkZ14kOuSQatbb7j07I+jvvDCKpdlaR3rijT4s=";
  };

  propagatedBuildInputs = [ lwt ppxlib ];

  meta = {
    description = "Ppx syntax extension for Lwt";
    inherit (lwt.meta) license homepage maintainers;
  };
}
