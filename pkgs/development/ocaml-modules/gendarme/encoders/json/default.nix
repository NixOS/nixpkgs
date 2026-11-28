{
  lib,
  mkGendarmeEncoder,
  gendarme-ezjsonm,
}:

mkGendarmeEncoder {
  propagatedBuildInputs = [
    gendarme-ezjsonm
  ];

  meta.description = "Metapackage for JSON marshalling using Gendarme";
}
