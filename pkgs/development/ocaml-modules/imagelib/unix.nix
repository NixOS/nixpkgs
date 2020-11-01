{ buildDunePackage, imagelib }:

buildDunePackage {
  pname = "imagelib-unix";
  inherit (imagelib) version src useDune2 meta;

  propagatedBuildInputs = [ imagelib ];
}
