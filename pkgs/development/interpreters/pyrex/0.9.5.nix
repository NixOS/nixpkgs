{ stdenv, fetchurl, builderDefs, python }:

let

  localDefs = builderDefs.passthru.function {

    src = fetchurl {
      url = http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/oldtar/Pyrex-0.9.5.1.1.tar.gz;
      sha256 = "0lxxvn4mjfb83swcbqb5908q4iy53w4ip5i0f9angm2va1jyhd3z";
    };

    buildInputs = [python];

  }; 

in with localDefs;
        
stdenv.mkDerivation rec {
  name = "pyrex-0.9.5.1.1";
  builder = writeScript (name + "-builder")
    (textClosure localDefs [installPythonPackage doForceShare]);
  meta = {
    description = "Python package compiler or something like that";
    inherit src;
  };
}
