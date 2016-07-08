{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, kparts
, ktexteditor
, kwidgetsaddons
, libkomparediff2
}:

kdeApp {
  name = "kompare";
  meta = {
    license = with lib.licenses; [ gpl2 ];
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];

  propagatedBuildInputs = [
    kparts
    ktexteditor
    kwidgetsaddons
    libkomparediff2
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/kompare"
  '';
}
