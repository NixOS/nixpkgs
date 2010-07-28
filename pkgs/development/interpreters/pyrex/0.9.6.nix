{ stdenv, fetchurl, builderDefs, python }:

let

  localDefs = builderDefs.passthru.function {

    src = fetchurl {
      url = http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/oldtar/Pyrex-0.9.6.4.tar.gz;
      sha256 = "18pd9f8al3l6i27cc0ddhgg7hxf28lnfs75x4a8jzscydxgiq5a8";
    };

    buildInputs = [python];

  };

in with localDefs;
        
stdenv.mkDerivation rec {
  name = "pyrex-0.9.6.4";
  builder = writeScript (name + "-builder")
    (textClosure localDefs [installPythonPackage doForceShare]);
  meta = {
    description = "Python package compiler or something like that";
    inherit src;
  };
}
