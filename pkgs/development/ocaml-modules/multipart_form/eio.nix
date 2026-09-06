{
  buildDunePackage,
  multipart_form,
  angstrom,
  bigstringaf,
  eio,
  ke,
}:

buildDunePackage {
  pname = "multipart_form-eio";

  inherit (multipart_form) version src meta;

  propagatedBuildInputs = [
    angstrom
    bigstringaf
    eio
    ke
    multipart_form
  ];
}
