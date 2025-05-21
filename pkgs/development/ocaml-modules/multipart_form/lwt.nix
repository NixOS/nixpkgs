{
  buildDunePackage,
  multipart_form,
  lwt,
}:

buildDunePackage {
  pname = "multipart_form-lwt";

  inherit (multipart_form) version src meta;

  propagatedBuildInputs = [
    lwt
    multipart_form

  ];
}
