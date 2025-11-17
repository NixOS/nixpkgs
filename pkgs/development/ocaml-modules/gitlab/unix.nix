{
  buildDunePackage,
  gitlab,
  cmdliner,
  cohttp,
  cohttp-lwt-unix,
  tls,
  lwt,
  stringext,
  alcotest,
}:

buildDunePackage {
  pname = "gitlab-unix";
  inherit (gitlab) version src;

  minimalOCamlVersion = "4.08";

  postPatch = ''
    substituteInPlace unix/dune --replace-fail "gitlab bytes" "gitlab"
  '';

  buildInputs = [
    cohttp
    tls
    stringext
  ];

  propagatedBuildInputs = [
    gitlab
    cmdliner
    cohttp-lwt-unix
    lwt
  ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = gitlab.meta // {
    description = "Gitlab APIv4 Unix library";
  };
}
