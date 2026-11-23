# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qt3d-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-5fBi08nKSS4eLhcve/DjW+UpgFsSlNC3NNdyItqtSEk=";
      name = "qt3d-everywhere-src-6.12.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qt5compat-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-MvR/aN4SmdSPrwKFi+Zv1wjuEnOxV55PrUdOfnKDGLU=";
      name = "qt5compat-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtactiveqt-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-H1wLhokAH6mdZchkdzU7TQA70CtkNDfAwPJMgzAj11Y=";
      name = "qtactiveqt-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtbase-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-zYN7uf1jHiBDmgTqoMLyUvGa2S/fWt8QIp0PvC+rLVM=";
      name = "qtbase-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtcanvaspainter = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtcanvaspainter-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-YWid8on67vSoMvTtbuiy5AjwpXcQHmEHDapCxUwizj0=";
      name = "qtcanvaspainter-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtcharts-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-un7x7I/NG3DQoNOdMZJACbFG68ONuStlejk4fjPCzQc=";
      name = "qtcharts-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtconnectivity-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-4DGdLzZbwSi0WwUayd5UJAJ50mGIJWu5seidOpnzvmI=";
      name = "qtconnectivity-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtdatavis3d-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-3dscmnUsGO9NI5NwdsAyLom/7diptskAgcC5+11Y+6k=";
      name = "qtdatavis3d-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtdeclarative-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-kYU+Ute6lYv9hepGte/PSjsosC57zQ58l6e3l+1tHsw=";
      name = "qtdeclarative-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtdoc-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-kSRicIDGlvfEgamEHIxij8s9n1dNasRLKD/D1JIkYmw=";
      name = "qtdoc-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtgraphs-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-Qb9SwTq2TmkDdgQYe6jSBGO50dspLY4q2J4b4EoUKY0=";
      name = "qtgraphs-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtgrpc-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-toBosLYJJN3mGZlQ/w+BP+uT999iofLIVOY9u2tQn2c=";
      name = "qtgrpc-everywhere-src-6.12.1.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qthttpserver-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-6yAEvIqXA/GVMLwvleG1q3u91xns6LiwKKfzBNYjwCs=";
      name = "qthttpserver-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtimageformats-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-IKQHMiKM8HNMWyM11KgWwcq5fc3MbRMHPAsQZeHGxgg=";
      name = "qtimageformats-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtlanguageserver-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-TpMVoF+573yOM9EHexHqQKNklHqKd3aLtNq1ihiep+c=";
      name = "qtlanguageserver-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtlocation = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtlocation-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-K/nJ9IVQQSstTRjz+nus2a+aI2qIoTdtxXQb4vb563s=";
      name = "qtlocation-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtlottie-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-kOY7hdhTvnpGwFzUa+9u0h5FKqDed/UJ/jcssWWhbTQ=";
      name = "qtlottie-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtmultimedia-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-WhJbwr7ejGUSKW4PMgSpkidB/RRPyufUpms8AHuxJeM=";
      name = "qtmultimedia-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtnetworkauth-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-eW/OBa/iWnEA50GSVn+QrAj2d6Aqvtv9Q2tS79rtdIc=";
      name = "qtnetworkauth-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtopenapi = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtopenapi-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-zH6X/IdOmp/HcVzVSdCE91I7S0Z+tA/LeEWU1KTYMSU=";
      name = "qtopenapi-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtpositioning-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-jYonZgxSxFrXGrVSlowbBzkSzQmk64ZO9nt9YTPnT+8=";
      name = "qtpositioning-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtquick3d-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-Mrp6Y38Fri4ZiyFagUo5Rba53dO1+v/yQGQ2mUzMCEM=";
      name = "qtquick3d-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtquick3dphysics-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-Su/TSzcOrGzRIhJL8ukM0Kn+izKb98FOLI6gE7vTVI4=";
      name = "qtquick3dphysics-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtquickeffectmaker-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-na2Clbe90b2wKi0l9sna+y1Lzfy/TeePwIefCfGTPLE=";
      name = "qtquickeffectmaker-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtquicktimeline-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-LeqHL6Ag9/CxKjQBJ8iBCM/wBDnlT2v+YYU1B+jwFhc=";
      name = "qtquicktimeline-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtremoteobjects-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-vhPsHeG5NioREpE4cfOQq7C8haYf8jnuo5KSZKzhCtg=";
      name = "qtremoteobjects-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtscxml-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-2GwAmQGSBzLn5Xmyv1Dm1rnptkxvcLdeSU62i5j9ldU=";
      name = "qtscxml-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtsensors-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-aJZbmtBzxPU1y2AohY8CF8yjIKf8oIcAXYXXdQyq9/s=";
      name = "qtsensors-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtserialbus-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-qJMv6Slx5tuNRpQGe0hdWfUHVU9WRo1OAAuihbSw0BA=";
      name = "qtserialbus-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtserialport-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-7gVRHUmTQ4trK6vY34+ProxeeqtWMJDdgfHwvpu7M3Q=";
      name = "qtserialport-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtshadertools-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-+MW5yR7KCScZiRjFN9G01RX5bcmjsXioih/x0vhceHc=";
      name = "qtshadertools-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtspeech = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtspeech-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-nfe6tmRZer8J1fOgEqSHVFEl4qL4tYVoHM/RhNnqzb0=";
      name = "qtspeech-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtsvg-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-anFXqaBVahKa5lgsf75XoNbAuDCDz8vTjV1Kk7MMRuE=";
      name = "qtsvg-everywhere-src-6.12.1.tar.xz";
    };
  };
  qttasktree = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qttasktree-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-RE3YYPg9o/rcaf19VSMH7ob5Bq2kaDjFt1OAaXhOfu8=";
      name = "qttasktree-everywhere-src-6.12.1.tar.xz";
    };
  };
  qttools = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qttools-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-DT0afroy0Ud/NiEftSfCx19gyxDz3cQf24BP2UFHtkA=";
      name = "qttools-everywhere-src-6.12.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qttranslations-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-XVN6C4Sd+aBYb7IENc4jK8PiHpUCUTT26o9cwZYiFYo=";
      name = "qttranslations-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtvirtualkeyboard-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-yvswzza8Z8SGkR2gXwTdyPLillVAmZB4rv9+2AnRgDw=";
      name = "qtvirtualkeyboard-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtwayland-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-Imyvz9O4wAnxeNFX0HcvkC9u5pPuOdIZq6UO7wRzwUM=";
      name = "qtwayland-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtwebchannel-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-G7r5oj+Afz0d10m4W9nBRejunKk2HgCyMhiXkEIJ0J4=";
      name = "qtwebchannel-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtwebsockets-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-qNkeRkmyLp9gbrHzY6EPd6yC0cIpRdX/PIio90EKDY4=";
      name = "qtwebsockets-everywhere-src-6.12.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.12.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.1/submodules/qtwebview-everywhere-src-6.12.1.tar.xz";
      hash = "sha256-S0KiYSR7DGGIIW0CZ1TCx3n2IqHlzKW4YzOeNsEzJ5g=";
      name = "qtwebview-everywhere-src-6.12.1.tar.xz";
    };
  };
}
