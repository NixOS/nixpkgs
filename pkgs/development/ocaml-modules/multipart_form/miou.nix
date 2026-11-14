{
  buildDunePackage,
  multipart_form,
  miou,
}:

buildDunePackage {
  pname = "multipart_form-miou";

  inherit (multipart_form) version src meta;

  propagatedBuildInputs = [
    miou
    multipart_form
  ];
}
