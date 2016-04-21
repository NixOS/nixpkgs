{ fetchpatch, plasmaPackage, extra-cmake-modules, kauth, kcompletion
, kconfigwidgets, kcoreaddons, kservice, kwidgetsaddons
, kwindowsystem, plasma-framework, qtscript, qtwebkit, qtx11extras
, kconfig, ki18n, kiconthemes
}:

plasmaPackage {
  name = "libksysguard";
  patches = [
    ./0001-qdiriterator-follow-symlinks.patch
    (fetchpatch { # should be included on update
      name = "glibc-2.23-isnan.patch";
      url = https://github.com/KDE/libksysguard/commit/b0578798eb3.patch;
      sha256 = "1my5nqp58c5azyi265j261a10wh047zxakprrnpl85mlg7bwskdh";
    })
  ];
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcompletion kconfigwidgets kcoreaddons kservice
    kwidgetsaddons qtscript qtwebkit
  ];
  propagatedBuildInputs = [
    kauth kconfig ki18n kiconthemes kwindowsystem plasma-framework
    qtx11extras
  ];
}
