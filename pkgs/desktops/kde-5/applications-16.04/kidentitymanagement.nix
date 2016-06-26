{ extra-cmake-modules
, kcompletion
, kcoreaddons
, kdeApp
, kemoticons
, kio
, kpimtextedit
, ktextwidgets
, kxmlgui
, lib
}:

kdeApp {
  name = "kidentitymanagement";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcompletion
    kcoreaddons
    kemoticons
    kio
    kpimtextedit
    ktextwidgets
    kxmlgui
  ];
}
