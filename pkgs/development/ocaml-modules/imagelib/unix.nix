{ buildDunePackage, imagelib }:

buildDunePackage {
  pname = "imagelib-unix";
  inherit (imagelib) version src meta;

  propagatedBuildInputs = [ imagelib ];
}
