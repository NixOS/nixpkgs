{ buildDunePackage, gnuplot, ocaml_lwt, metrics, metrics-lwt, mtime, uuidm }:

buildDunePackage rec {

  pname = "metrics-unix";

  inherit (metrics) version useDune2 src;

  propagatedBuildInputs = [ gnuplot ocaml_lwt metrics mtime uuidm ];

  checkInputs = [ metrics-lwt ];

  doCheck = true;

  meta = metrics.meta // {
    description = "Unix backend for the Metrics library";
  };

}
