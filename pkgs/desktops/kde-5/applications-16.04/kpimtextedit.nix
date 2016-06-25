{ extra-cmake-modules
, grantlee
, kcoreaddons
, kdeApp
, kdesignerplugin
, kemoticons
, kio
, ktextwidgets
, lib
, sonnet
}:

kdeApp {
  name = "kpimtextedit";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    grantlee
    kcoreaddons
    kdesignerplugin
    kemoticons
    kio
    ktextwidgets
    sonnet
  ];
}
