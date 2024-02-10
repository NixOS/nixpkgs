{ buildDunePackage, gnuplot, lwt, metrics, metrics-lwt, mtime, uuidm }:

buildDunePackage rec {

  pname = "metrics-unix";

  inherit (metrics) version src;

  propagatedBuildInputs = [ gnuplot lwt metrics mtime uuidm ];

  nativeCheckInputs = [ gnuplot ];
  checkInputs = [ metrics-lwt ];

  doCheck = true;

  meta = metrics.meta // {
    description = "Unix backend for the Metrics library";
  };

}
