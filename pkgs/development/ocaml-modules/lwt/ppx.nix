{ fetchzip, buildDunePackage, lwt, ppx_tools_versioned }:

buildDunePackage {
  pname = "lwt_ppx";
  version = "2.0.1";

  src = fetchzip {
    # `lwt_ppx` has a different release cycle than Lwt, but it's included in
    # one of its release bundles.
    # Because there could exist an Lwt release _without_ a `lwt_ppx` release,
    # this `src` field doesn't inherit from the Lwt derivation.
    #
    # This is particularly useful for overriding Lwt without breaking `lwt_ppx`,
    # as new Lwt releases may contain broken `lwt_ppx` code.
    url = "https://github.com/ocsigen/lwt/archive/5.2.0.tar.gz";
    sha256 = "1znw8ckwdmqsnrcgar4g33zgr659l4l904bllrz69bbwdnfmz2x3";
  };


  propagatedBuildInputs = [ lwt ppx_tools_versioned ];

  meta = {
    description = "Ppx syntax extension for Lwt";
    inherit (lwt.meta) license homepage maintainers;
  };
}
