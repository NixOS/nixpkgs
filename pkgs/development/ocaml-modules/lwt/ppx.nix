{ fetchzip, buildDunePackage, lwt, ppx_tools_versioned }:

buildDunePackage {
  pname = "lwt_ppx";
  version = "1.2.4";

  src = fetchzip {
    # `lwt_ppx` has a different release cycle than Lwt, but it's included in
    # one of its release bundles.
    # Because there could exist an Lwt release _without_ a `lwt_ppx` release,
    # this `src` field doesn't inherit from the Lwt derivation.
    #
    # This is particularly useful for overriding Lwt without breaking `lwt_ppx`,
    # as new Lwt releases may contain broken `lwt_ppx` code.
    url = "https://github.com/ocsigen/lwt/archive/4.4.0.tar.gz";
    sha256 = "1l97zdcql7y13fhaq0m9n9xvxf712jg0w70r72fvv6j49xm4nlhi";
  };


  propagatedBuildInputs = [ lwt ppx_tools_versioned ];

  meta = {
    description = "Ppx syntax extension for Lwt";
    inherit (lwt.meta) license homepage maintainers;
  };
}
