{ mkDerivation, lib, fetchFromGitLab
, qmake, qtbase
}:

mkDerivation rec {
  pname = "libqofono";
  version = "0.103";

  src = fetchFromGitLab {
    domain = "git.sailfishos.org";
    owner = "mer-core";
    repo = "libqofono";
    rev = version;
    sha256 = "1ly5aj412ljcjvhqyry6nhiglbzzhczsy1a6w4i4fja60b2m1z45";
  };

  postPatch = ''
    for proFile in {src/src,test/auto/{tests/tests.xml,tst_qofono/tst_qofono},ofonotest/ofonotest}.pro test/auto/tests/testcase.pri; do
      substituteInPlace $proFile \
        --replace '$''\$[QT_INSTALL_LIBS]' "$out/lib" \
        --replace '$''\$[QT_INSTALL_PREFIX]' "$out" \
        --replace '/opt' "$out/opt"
    done
  '';

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "A library for accessing the ofono daemon, and a declarative plugin for it";
    homepage = "https://git.sailfishos.org/mer-core/libqofono";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
