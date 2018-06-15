{ build-idris-package
, fetchFromGitHub
, prelude
, effects
, lib
, idris
}:
build-idris-package  {
  name = "eternal";
  version = "2018-01-25";

  idrisDeps = [ prelude effects ];

  src = fetchFromGitHub {
    owner = "Heather";
    repo = "Control.Eternal.Idris";
    rev = "7ead56ce6065b55104460ace945adbce38fb13eb";
    sha256 = "0b4zys4mhl6r4rbpdxr7n2n20cdc0nkh4lm8n5v4wxkmjzna5cpd";
  };

  postUnpack = ''
    printf 'makefile = Makefile\n' >> source/eternal.ipkg
    printf 'objs = readProcess.o\n' >> source/eternal.ipkg
    sed -i 's/\/usr\/local\/idris\/readProcess.h/readProcess.h/g' source/Control/Eternal/System/Process.idr
    sed -i 's/\/usr\/local\/idris\/readProcess.o/readProcess.o/g' source/Control/Eternal/System/Process.idr
  '';

  meta = {
    description = "Infix pipe operators and some Nat, Float, String conversions";
    homepage = https://github.com/Heather/Control.Eternal.Idris;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
