{ buildDunePackage, lwt, ppx_tools_versioned }:

buildDunePackage {
  pname = "lwt_ppx";

  inherit (lwt) src version;

  propagatedBuildInputs = [ lwt ppx_tools_versioned ];

  meta = {
    description = "Ppx syntax extension for Lwt";
    inherit (lwt.meta) license homepage maintainers;
  };
}
