{ kdeFramework, lib, copyPathsToStore, fetchurl
, ecm, perl
, karchive, kconfig, kguiaddons, kiconthemes, kparts
, libgit2
, qtscript, qtxmlpatterns
, ki18n, kio, sonnet
}:

kdeFramework {
  name = "ktexteditor";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = [
    (fetchurl {
      url = "https://cgit.kde.org/ktexteditor.git/patch/?id=2c4feeb0c9107732399f8ae3dacea3124572f345";
      sha256 = "13pq9h9iry8c59cnv9gfwgvb7vaj3dz5hmc5wkjqf8iwc1fv4m1v";
      name = "ktexteditor-searchbar-enter-methods.patch";
    })
    (fetchurl {
      url = "https://cgit.kde.org/ktexteditor.git/patch/?id=09a1e864d54735ebcab6bf31198fdef969b92a67";
      sha256 = "120743xbh5rx4zjd2p0bjki9kkv1qmxsrgd8qlis7x2szrlhrb46";
      name = "ktexteditor-text-folding-cursor-valid.patch";
    })
    (fetchurl {
      url = "https://cgit.kde.org/ktexteditor.git/patch/?id=86f1dde943389bbf211ec1cde3f27c9681351d3f";
      sha256 = "0al3g1gg7rw7c71vgwpfdz7qpdyhyq11338f4ady6zssj6xx1i4k";
      name = "ktexteditor-multiple-messages.patch";
    })
  ];
  nativeBuildInputs = [ ecm perl ];
  propagatedBuildInputs = [
    karchive kconfig kguiaddons ki18n kiconthemes kio kparts libgit2 qtscript
    qtxmlpatterns sonnet
  ];
}
