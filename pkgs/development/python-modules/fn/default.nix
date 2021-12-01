{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "fn";
  version = "0.4.3";

  meta = {
    description = ''
      Functional programming in Python: implementation of missing
      features to enjoy FP
    '';
    homepage = "https://github.com/kachayev/fn.py";
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nmsjmn8jb4gp22ksx0j0hhdf4y0zm8rjykyy2i6flzimg6q1kgq";
  };
}
