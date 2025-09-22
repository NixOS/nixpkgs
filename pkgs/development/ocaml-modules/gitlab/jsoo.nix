{
  buildDunePackage,
  gitlab,
  cohttp,
  cohttp-lwt-jsoo,
  js_of_ocaml-lwt,
}:

buildDunePackage {
  pname = "gitlab-jsoo";
  inherit (gitlab) version src;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    gitlab
    cohttp
    cohttp-lwt-jsoo
    js_of_ocaml-lwt
  ];

  doCheck = true;

  meta = gitlab.meta // {
    description = "Gitlab APIv4 JavaScript library";
  };
}
