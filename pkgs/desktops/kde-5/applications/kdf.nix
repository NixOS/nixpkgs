{
  kdeApp, lib, kdeWrapper,
  ecm, kdoctools,
  kcmutils
}:

let
  unwrapped =
    kdeApp {
      name = "kdf";
      meta = {
        license = with lib.licenses; [ gpl2 ];
        maintainers = [ lib.maintainers.peterhoeg ];
      };
      nativeBuildInputs = [ ecm kdoctools ];
      propagatedBuildInputs = [
        kcmutils
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kdf" ];
}
