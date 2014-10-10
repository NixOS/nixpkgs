{  }: {
  attica = {
    name = "attica-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/attica-5.3.0.tar.xz;
      sha256 = "1mzrm0bbzlky1csli2ldj4dr8xn314cn1310qz263hqay1jhln80";
      name = "attica-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  extra-cmake-modules = {
    name = "extra-cmake-modules-1.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/extra-cmake-modules-1.3.0.tar.xz;
      sha256 = "08y7wjk86amgrc5g7gpps9l5pv927j0l16bhvw9w6bbvidj6m2za";
      name = "extra-cmake-modules-1.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "dbusmenuqt";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "egl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "eigen2";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "exiv2";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kde4workspace";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kdevplatform";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kdewin";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5archive";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "lcms";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "libattica";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pkgconfig";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "polkitqt";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "polkitqt-1";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pulseaudio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pythoninterp";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt4";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5linguisttools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "shareddesktopontologies";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "soprano";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "strigi";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  frameworkintegration = {
    name = "frameworkintegration-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/frameworkintegration-5.3.0.tar.xz;
      sha256 = "0jyp87jzly1wy9kbpzx6gkizk1ybvskwa6cwbc8zv9871m21bf3c";
      name = "frameworkintegration-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5notifications";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "oxygenfont";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "xcb";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kactivities = {
    name = "kactivities-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kactivities-5.3.0.tar.xz;
      sha256 = "0lwz7d3ij22jq61crk9hmbpf4xdh2fjfjlh74nszj6x6h8zm0i7p";
      name = "kactivities-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5declarative";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kapidox = {
    name = "kapidox-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kapidox-5.3.0.tar.xz;
      sha256 = "0j8pf08h0xy8154psjs0hjn7n18npmav6w4vpbccdgahabi6qphq";
      name = "kapidox-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pythoninterp";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  karchive = {
    name = "karchive-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/karchive-5.3.0.tar.xz;
      sha256 = "0rpf8rw2ms5r3xn0jqsr4srb1b3dsykwcldhhzir8rlms10yn5cj";
      name = "karchive-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "bzip2";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5archive";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "liblzma";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "zlib";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kauth = {
    name = "kauth-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kauth-5.3.0.tar.xz;
      sha256 = "1l1zbvbcmqpcgcsgmxfaqpqdgaqbhkb11834kq2i13q95d8rg8h3";
      name = "kauth-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pkgconfig";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "polkitqt";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "polkitqt-1";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "polkitqt5-1";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kbookmarks = {
    name = "kbookmarks-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kbookmarks-5.3.0.tar.xz;
      sha256 = "0hag7xg2asbgdnsm1asb4njq27cxap1swcvm7kcx4j6kf56mzs9w";
      name = "kbookmarks-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kcmutils = {
    name = "kcmutils-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kcmutils-5.3.0.tar.xz;
      sha256 = "1hkz5fjwb6wlx1zq3wa3kca1w0rixr7p84k2i535sw292vvhgh6m";
      name = "kcmutils-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5itemviews";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kcodecs = {
    name = "kcodecs-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kcodecs-5.3.0.tar.xz;
      sha256 = "0gfg2zli80608k5i1n9cl7qjj3sd95ipv17k3781q18s93s92zi5";
      name = "kcodecs-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kcompletion = {
    name = "kcompletion-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kcompletion-5.3.0.tar.xz;
      sha256 = "1bq95dvx08wgp5a8rk9q4wi8f8kn73ibnrlzqsy8qhwywaw4zfsf";
      name = "kcompletion-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kconfig = {
    name = "kconfig-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kconfig-5.3.0.tar.xz;
      sha256 = "06ixglzggj62dzifagiq18v6cq126h87rf9asycxhm2lnbfmmb1c";
      name = "kconfig-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5concurrent";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5gui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5xml";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kconfigwidgets = {
    name = "kconfigwidgets-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kconfigwidgets-5.3.0.tar.xz;
      sha256 = "18kn8csgmm18ji31pqisg3a13arha334q0y39vb6vknadjavkdb7";
      name = "kconfigwidgets-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5auth";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5codecs";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5guiaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kcoreaddons = {
    name = "kcoreaddons-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kcoreaddons-5.3.0.tar.xz;
      sha256 = "0wmrkshr5x89p954lhg0c8n1pylc0h8klgh2if2d1z49sjn3l13i";
      name = "kcoreaddons-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "fam";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "sharedmimeinfo";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kcrash = {
    name = "kcrash-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kcrash-5.3.0.tar.xz;
      sha256 = "1jlqv78msph6qkdrs8ff56zz011r2xglnw0k3c9a9k5rlwk3vwg5";
      name = "kcrash-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5x11extras";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kdbusaddons = {
    name = "kdbusaddons-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kdbusaddons-5.3.0.tar.xz;
      sha256 = "19z8yr4agddk76806h6sb1xp2zp012xp12d6yl0ky3qhsqdcbbpd";
      name = "kdbusaddons-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5dbus";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5x11extras";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kdeclarative = {
    name = "kdeclarative-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kdeclarative-5.3.0.tar.xz;
      sha256 = "1s4grf78cgp9h50c4944k62vcqpn8ahpwmkgl929370bjhg8g8vj";
      name = "kdeclarative-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5globalaccel";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5guiaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kded = {
    name = "kded-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kded-5.3.0.tar.xz;
      sha256 = "0q4wmkirfx7pv0i01jkmi97bjj338jz9w4ksj51kcrm3yhwg9bki";
      name = "kded-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5crash";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5dbusaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5init";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kdesignerplugin = {
    name = "kdesignerplugin-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kdesignerplugin-5.3.0.tar.xz;
      sha256 = "1sbrksvc8s6k7pcpy0q2wy5g4hm0qaq8m3dlmpxyz8af2ny7m024";
      name = "kdesignerplugin-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5completion";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5itemviews";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5plotting";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5sonnet";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5textwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5webkit";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5designer";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kdesu = {
    name = "kdesu-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kdesu-5.3.0.tar.xz;
      sha256 = "194rghv3cqa0m6wvnh7f1kqqiy1kb8j3zywzh8x28syb1q3634ai";
      name = "kdesu-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5pty";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kdewebkit = {
    name = "kdewebkit-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kdewebkit-5.3.0.tar.xz;
      sha256 = "10dlc4xzpcgfadl58p8biyyc4mlm42hq365fdlva70lfh85zp8rv";
      name = "kdewebkit-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5jobwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5parts";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5wallet";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kdnssd = {
    name = "kdnssd-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kdnssd-5.3.0.tar.xz;
      sha256 = "1sdbpa6hxgbwqdh8xhb51nlk5z33sfb38jlavv8y6dym3k9n7nq1";
      name = "kdnssd-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "avahi";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "dnssd";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kdoctools = {
    name = "kdoctools-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kdoctools-5.3.0.tar.xz;
      sha256 = "0vgfphrxhn2whgw4v666yn8rrxmxg2s77kgbz27n7xkkwbb9zlvw";
      name = "kdoctools-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "docbookxml4";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "docbookxsl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5archive";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "libxml2";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "libxslt";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kemoticons = {
    name = "kemoticons-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kemoticons-5.3.0.tar.xz;
      sha256 = "0w7d7lsrfi8zmrq7ir0qnpb76xr5l2357v3qb75c4v7p4cbaasz0";
      name = "kemoticons-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5archive";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5xml";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kglobalaccel = {
    name = "kglobalaccel-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kglobalaccel-5.3.0.tar.xz;
      sha256 = "1mfsfl7ji09xlzy7a8h6gj8grfyvr84gyxls62av4l076mr6ajs1";
      name = "kglobalaccel-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kguiaddons = {
    name = "kguiaddons-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kguiaddons-5.3.0.tar.xz;
      sha256 = "1gl6gnyvx3mlz5g9vbb0rylr7sq5xfgsd0alickjm2m41ay3izzn";
      name = "kguiaddons-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5gui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5x11extras";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "xcb";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  ki18n = {
    name = "ki18n-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/ki18n-5.3.0.tar.xz;
      sha256 = "108gwcp8gpjqh5k4rr7jybmfaccrq2ln290yil122qyzmhjr1cgv";
      name = "ki18n-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "gettext";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "libintl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pythoninterp";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kiconthemes = {
    name = "kiconthemes-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kiconthemes-5.3.0.tar.xz;
      sha256 = "1kka3yd0yf5nabkxni5xzlxhj7gdz40zm3maw7ymj74crhwl110i";
      name = "kiconthemes-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5itemviews";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5dbus";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5svg";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kidletime = {
    name = "kidletime-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kidletime-5.3.0.tar.xz;
      sha256 = "06y2xm2yrqrh30i2jq7qmcmz5g6s7dy4sxzgi9vha5jq4fx5b3gi";
      name = "kidletime-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11_xcb";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "xcb";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kimageformats = {
    name = "kimageformats-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kimageformats-5.3.0.tar.xz;
      sha256 = "1i53rw6mzamrcawr2qnz8pm6wj8nvp8cmcvdai8apd2wrvaby6rk";
      name = "kimageformats-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "jasper";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "openexr";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5gui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5printsupport";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kinit = {
    name = "kinit-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kinit-5.3.0.tar.xz;
      sha256 = "148a5gwqhc4d4vacl2zv6b9wpmb3xjrfaydc323war9bc4pjirw8";
      name = "kinit-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5crash";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "libcap";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kio = {
    name = "kio-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kio-5.3.0.tar.xz;
      sha256 = "15zhsh430gfgafhz9md6qk4dncx35pgzwhz07m30zi0w514j4g07";
      name = "kio-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "acl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "gssapi";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5archive";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5bookmarks";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5codecs";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5completion";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5dbusaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5itemviews";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5jobwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5notifications";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5solid";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5wallet";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "libxml2";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "libxslt";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "openssl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5concurrent";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5script";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "strigi";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "zlib";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kitemmodels = {
    name = "kitemmodels-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kitemmodels-5.3.0.tar.xz;
      sha256 = "1039mdynp6fv6v3hyvr2r1zdhz2dja5k1qav4fbgyzs4ijardz95";
      name = "kitemmodels-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "grantlee";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5script";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kitemviews = {
    name = "kitemviews-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kitemviews-5.3.0.tar.xz;
      sha256 = "19lfv885l87b5kqh36bgdd1j8xx3zjah5kwjwvj41jngyji3dcrh";
      name = "kitemviews-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kjobwidgets = {
    name = "kjobwidgets-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kjobwidgets-5.3.0.tar.xz;
      sha256 = "136jw4cqr48ddfgbl77cby69xxhqqnn7cqawia6qimxjwsi5cdw9";
      name = "kjobwidgets-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5x11extras";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  knewstuff = {
    name = "knewstuff-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/knewstuff-5.3.0.tar.xz;
      sha256 = "1wfidsiypspa2ndwg3hdy2h8zf0bvyr87rp8p1vqw03v50lrcvry";
      name = "knewstuff-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5archive";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5attica";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5completion";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5itemviews";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5textwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  knotifications = {
    name = "knotifications-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/knotifications-5.3.0.tar.xz;
      sha256 = "02wf0f4fn9bwpwk2iq134nqms2kvq858lx9jhyrvhv80sh28mvf7";
      name = "knotifications-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "dbusmenu-qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5codecs";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "phonon4qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5x11extras";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  knotifyconfig = {
    name = "knotifyconfig-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/knotifyconfig-5.3.0.tar.xz;
      sha256 = "138ii5y4jc5vnqn5ar5xh0fgs72nj1anj67bqs8acw4xb9yy0hs9";
      name = "knotifyconfig-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5completion";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5notifications";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "phonon4qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kparts = {
    name = "kparts-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kparts-5.3.0.tar.xz;
      sha256 = "10si19vy2fwvxflcpai4qa6fx3rrwjvlhabin9sdqsbbhffys0iy";
      name = "kparts-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5jobwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5notifications";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5textwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kplotting = {
    name = "kplotting-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kplotting-5.3.0.tar.xz;
      sha256 = "0r96913xjlixwp3pzwfbfr0lki3gdncrjmcjagc5hg7w7b89l6gc";
      name = "kplotting-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kpty = {
    name = "kpty-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kpty-5.3.0.tar.xz;
      sha256 = "07sahnagkzv2vc8sibgvvlzdv8nxlbq0qhl51cvv2jn8vgd9hply";
      name = "kpty-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kservice = {
    name = "kservice-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kservice-5.3.0.tar.xz;
      sha256 = "0nx04wxwl46i34q5ni7b15bkhfcrsppp2l085saf9m4f8kiz9bv8";
      name = "kservice-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5crash";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5dbusaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  ktexteditor = {
    name = "ktexteditor-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/ktexteditor-5.3.0.tar.xz;
      sha256 = "000mhriw02lrv50g96a4r6ia03jchz9b5626j8z3zwdyg68nkg07";
      name = "ktexteditor-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5archive";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5guiaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5parts";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5sonnet";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "libgit2";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "perl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  ktextwidgets = {
    name = "ktextwidgets-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/ktextwidgets-5.3.0.tar.xz;
      sha256 = "0xfs174d5i5m2cy5j0b9s886pfr2lp9y6kgjvr8lad90ms8jlfdc";
      name = "ktextwidgets-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5completion";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5sonnet";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kunitconversion = {
    name = "kunitconversion-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kunitconversion-5.3.0.tar.xz;
      sha256 = "0sgzp0wy07mn3rjspzwxdsk9whvjgrj0z1cd633bb250g31g6sfj";
      name = "kunitconversion-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kwallet = {
    name = "kwallet-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kwallet-5.3.0.tar.xz;
      sha256 = "06q4snaz4rljf5zwxqwk5xd2pxi2rlffmv4xv2pida91sl4cfcqy";
      name = "kwallet-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "gpgme";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5dbusaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5gpgmepp";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5notifications";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "libgcrypt";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kwidgetsaddons = {
    name = "kwidgetsaddons-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kwidgetsaddons-5.3.0.tar.xz;
      sha256 = "0sfk6ll67ih62ryd3ikmh7xrfmwxdf78skbdirvac52jvr3smsl4";
      name = "kwidgetsaddons-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kwindowsystem = {
    name = "kwindowsystem-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kwindowsystem-5.3.0.tar.xz;
      sha256 = "0r2jvqdmjwk05qzd9chs34l3sgp3cfvhfx4p64k1asbmx2ahyry8";
      name = "kwindowsystem-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5winextras";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "xcb";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kxmlgui = {
    name = "kxmlgui-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/kxmlgui-5.3.0.tar.xz;
      sha256 = "01264fwpxqqbpa2xpzrr8r0v8ydyv5qws6544pmr70a8k13hm4cs";
      name = "kxmlgui-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5attica";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5globalaccel";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5itemviews";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5textwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  plasma-framework = {
    name = "plasma-framework-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/plasma-framework-5.3.0.tar.xz;
      sha256 = "1fp7skxg39k4limgq016rzkj1ax3nlnqnbzdmxg21w2bwqn2a3ms";
      name = "plasma-framework-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "egl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "gpgme";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kactivities";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kcoreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kde4support";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kdeclarative";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kdepimlibs";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kdesu";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5activities";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5archive";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5dbusaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5declarative";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5globalaccel";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5guiaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kde4support";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5parts";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5solid";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5su";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "opengl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qca2";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "solid";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "xcb";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  solid = {
    name = "solid-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/solid-5.3.0.tar.xz;
      sha256 = "0anb1d74p8jzzc8f7xqg03y4asf7h87aivyhhw566bl9sgdfnsi7";
      name = "solid-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "bison";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "flex";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "iokit";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "mediaplayerinfo";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5qml";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "udev";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  sonnet = {
    name = "sonnet-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/sonnet-5.3.0.tar.xz;
      sha256 = "1wy7m6k341wh7l31m4y47l52024bpwvdl9dkf61jyy9x975yq2l3";
      name = "sonnet-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "aspell";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "enchant";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "hspell";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "hunspell";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pkgconfig";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "zlib";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  threadweaver = {
    name = "threadweaver-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/threadweaver-5.3.0.tar.xz;
      sha256 = "0f58cpn08cbcknbwpk18skha06gwnjff4i0dkakvw833dvn1hn61";
      name = "threadweaver-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5threadweaver";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kdelibs4support = {
    name = "kdelibs4support-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/portingAids/kdelibs4support-5.3.0.tar.xz;
      sha256 = "17b6ndcqkbm7qisy7jzgbzwgp1brydm0wmn25w78rrl1mg2i09in";
      name = "kdelibs4support-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "docbookxml4";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "eigen2";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "exiv2";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "gettext";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kde4";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kde4internal";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kde4workspace";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kdevplatform";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kdewin";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kdewin_packager";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5completion";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5configwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5crash";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5designerplugin";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5globalaccel";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5guiaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5notifications";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5parts";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5textwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5unitconversion";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "lcms";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "libintl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "networkmanager";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "openssl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pkgconfig";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "polkitqt";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "polkitqt-1";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pulseaudio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pythoninterp";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pythonlibs";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qntrack";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt4";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5concurrent";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5printsupport";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5svg";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5webkitwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5x11extras";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "shareddesktopontologies";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "soprano";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  khtml = {
    name = "khtml-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/portingAids/khtml-5.3.0.tar.xz;
      sha256 = "1cpm9nbscpj2plq56k0jxv6a5g0jzi9qmmfd9775jlcpk54bji0a";
      name = "khtml-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "gif";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "jpeg";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kdewin";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5archive";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5codecs";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5globalaccel";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5js";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5notifications";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5parts";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5sonnet";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5textwidgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5wallet";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5windowsystem";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "openssl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "perl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "phonon4qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "png";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5x11extras";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "x11";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kjs = {
    name = "kjs-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/portingAids/kjs-5.3.0.tar.xz;
      sha256 = "1xmydgz4z3yxrfnyac5c46bdydv8hp3m6w39f9rr1ppa889q9k60";
      name = "kjs-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pcre";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "perl";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "pkgconfig";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5core";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kjsembed = {
    name = "kjsembed-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/portingAids/kjsembed-5.3.0.tar.xz;
      sha256 = "1447w2nk5w99j92sq22vvvgyih9y4idbxq3r188l8vidd5s3k6xx";
      name = "kjsembed-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5js";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kmediaplayer = {
    name = "kmediaplayer-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/portingAids/kmediaplayer-5.3.0.tar.xz;
      sha256 = "1103y1q5065yb01rywg7x0vmjddpcbcrkl367nbwmg8lr0iiqi72";
      name = "kmediaplayer-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5parts";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5dbus";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5test";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5widgets";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  kross = {
    name = "kross-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/portingAids/kross-5.3.0.tar.xz;
      sha256 = "0pj9nxw5p7agn8i3fgb0zkms6ncvgxn7x5yvjag0vin2g221fvkw";
      name = "kross-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5completion";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5doctools";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5iconthemes";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5parts";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5widgetsaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5xmlgui";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
  krunner = {
    name = "krunner-5.3.0";
    src = {
      url = mirror://kde/stable/frameworks/5.3.0/portingAids/krunner-5.3.0.tar.xz;
      sha256 = "01fvq920f8mpaczq5lz99sxxjgyxmk8gxrswbwzxmxzbgamz48ya";
      name = "krunner-5.3.0.tar.xz";
    };
    inputs = [
      {
        name = "cmake";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "ecm";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5config";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5coreaddons";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5i18n";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5kio";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5plasma";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5service";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5solid";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "kf5threadweaver";
        propagated = false;
        native = false;
        userEnv = false;
      }
      {
        name = "qt5";
        propagated = false;
        native = false;
        userEnv = false;
      }
    ];
  };
}