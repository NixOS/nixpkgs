{ ecm
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
    description = "Manage PIM identity";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    ecm
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
