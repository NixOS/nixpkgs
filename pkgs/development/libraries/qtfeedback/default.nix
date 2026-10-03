{
  lib,
  mkDerivation,
  fetchFromGitHub,
  perl,
  qmake,
  qtdeclarative,
}:

mkDerivation {
  pname = "qtfeedback";
  version = "unstable-2018-09-03";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtfeedback";
    rev = "a14bd0bb1373cde86e09e3619fb9dc70f34c71f2";
    hash = "sha256-R85oqU3hL3qFHp2NoAceLNHjOw7PzKxYoPipmLdzMU4=";
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

  meta = {
    description = "Qt Tactile Feedback";
    homepage = "https://github.com/qt/qtfeedback";
    license = with lib.licenses; [
      lgpl3Only # or
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [
      dotlambda
      OPNA2608
    ];
  };
}
