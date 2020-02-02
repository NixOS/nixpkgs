{ buildDunePackage, ocaml_lwt, metrics }:

buildDunePackage {
  pname = "metrics-lwt";

  inherit (metrics) version src;

  propagatedBuildInputs = [ ocaml_lwt metrics ];

  meta = metrics.meta // {
    description = "Lwt backend for the Metrics library";
  };

}
