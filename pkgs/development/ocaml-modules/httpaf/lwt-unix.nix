{
  buildDunePackage,
  httpaf,
  faraday-lwt-unix,
  lwt,
}:

buildDunePackage {
  pname = "httpaf-lwt-unix";
  inherit (httpaf) version src;
  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    faraday-lwt-unix
    httpaf
    lwt
  ];

  meta = httpaf.meta // {
    description = "Lwt support for http/af";
  };
}
