{ build-idris-package, fetchFromGitHub, lib, idris, base, prelude, bifunctors  }:

build-idris-package {
  name = "lens-2016-10-05";

  src = fetchFromGitHub {
    owner = "HuwCampbell";
    repo = "idris-lens";
    rev = "6664ef62396a956ee728b3a785acf77a60c3b670";
    sha256 = "1bcczp46p5kkqp5k07p49y08ch6m5rzkdlx5m9wpvmzwxr50wln8";
  };

  propagatedBuildInputs = [ prelude base bifunctors ];

  meta = {
    description = "Small port of Control.Lens to Idris";
    homepage = https://github.com/HuwCampbell/idris-lens;
    license = lib.licenses.bsd3;
    inherit (idris.meta) platforms;
  };
}
