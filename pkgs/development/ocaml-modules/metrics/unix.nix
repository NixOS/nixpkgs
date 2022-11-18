{ buildDunePackage, gnuplot, lwt, metrics, metrics-lwt, mtime, uuidm }:

buildDunePackage rec {

  pname = "metrics-unix";

  inherit (metrics) version src;

  # Fixes https://github.com/mirage/metrics/issues/57
  postPatch = ''
    substituteInPlace src/unix/dune --replace "mtime mtime.clock" "mtime"
  '';

  propagatedBuildInputs = [ gnuplot lwt metrics mtime uuidm ];

  checkInputs = [ metrics-lwt ];

  doCheck = true;

  meta = metrics.meta // {
    description = "Unix backend for the Metrics library";
  };

}
