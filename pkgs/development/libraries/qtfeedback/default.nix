{ lib
, mkDerivation
, fetchFromGitHub
, perl
, qmake
, qtdeclarative
}:

mkDerivation rec {
  pname = "qtfeedback";
  version = "unstable-2018-09-03";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtfeedback";
    rev = "a14bd0bb1373cde86e09e3619fb9dc70f34c71f2";
    sha256 = "0kiiffvriagql1cark6g1qxy7l9c3q3s13cx3s2plbz19nlnikj7";
  };

  nativeBuildInputs = [
    perl
    qmake
  ];

  buildInputs = [
    qtdeclarative
  ];

  qmakeFlags = [ "CONFIG+=git_build" ];

  doCheck = true;

  postFixup = ''
    # Drop QMAKE_PRL_BUILD_DIR because it references the build dir
    find "$out/lib" -type f -name '*.prl' \
      -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;
  '';

  meta = with lib; {
    description = "Qt Tactile Feedback";
    homepage = "https://github.com/qt/qtfeedback";
    license = with licenses; [ lgpl3Only /* or */ gpl2Plus ];
    maintainers = with maintainers; [ dotlambda OPNA2608 ];
  };
}
