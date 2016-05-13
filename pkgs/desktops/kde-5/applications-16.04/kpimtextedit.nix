{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, grantlee
, kcoreaddons
, kemoticons
, sonnet
, ktextwidgets
, kwidgetsaddons
, kio
, kiconthemes
}:

kdeApp {
  name = "kpimtextedit";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  propagatedbuildInputs = [
    grantlee
    kcoreaddons
    kemoticons
    sonnet
    ktextwidgets
    kwidgetsaddons
    kio
    kiconthemes
  ];


  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
