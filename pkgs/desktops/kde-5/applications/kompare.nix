{
  kdeApp, lib, kdeWrapper,
  ecm, kdoctools,
  kparts, ktexteditor, kwidgetsaddons, libkomparediff2
}:

let
  unwrapped =
    kdeApp {
      name = "kompare";
      meta = { license = with lib.licenses; [ gpl2 ]; };
      nativeBuildInputs = [ ecm kdoctools ];
      propagatedBuildInputs = [
        kparts ktexteditor kwidgetsaddons libkomparediff2
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kompare" ];
}
