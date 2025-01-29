{ build-idris-package
, fetchFromGitHub
, effects
, lib
}:
build-idris-package  {
  pname = "eternal";
  version = "2018-07-02";

  idrisDeps = [ effects ];

  src = fetchFromGitHub {
    owner = "Heather";
    repo = "Control.Eternal.Idris";
    rev = "2f84b0dd49a7a29a2f852ba96cabfe8322e0852b";
    sha256 = "1x8cwngiqi05f3wll0niznm47jj2byivx4mh5xf4sb47kciwkxvs";
  };

  postUnpack = ''
    printf 'makefile = Makefile\n' >> source/eternal.ipkg
    printf 'objs = readProcess.o\n' >> source/eternal.ipkg
    sed -i 's/\/usr\/local\/idris\/readProcess.h/readProcess.h/g' source/Control/Eternal/System/Process.idr
    sed -i 's/\/usr\/local\/idris\/readProcess.o/readProcess.o/g' source/Control/Eternal/System/Process.idr
  '';

  meta = {
    description = "Infix pipe operators and some Nat, Float, String conversions";
    homepage = "https://github.com/Heather/Control.Eternal.Idris";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
