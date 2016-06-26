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
    description = "Advanced text editor which provide advanced html feature.";
    license = with lib.licenses; [ lgpl21Plus ];
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
