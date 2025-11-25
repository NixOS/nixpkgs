# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qt3d-everywhere-src-6.10.1.tar.xz";
      sha256 = "16lw0gpjcaf90iqnff95hxw3hng42c8hzknxczf4h7kv9zakynb0";
      name = "qt3d-everywhere-src-6.10.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qt5compat-everywhere-src-6.10.1.tar.xz";
      sha256 = "097yvzmfz9w5xsrr3dxd2gv4q826mplwmw0wnh0ywg8m18b6sfbj";
      name = "qt5compat-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtactiveqt-everywhere-src-6.10.1.tar.xz";
      sha256 = "078bnj8a1faln3dibx14wxdsic5s94m00x73zwncfzx7ywczcr05";
      name = "qtactiveqt-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtbase-everywhere-src-6.10.1.tar.xz";
      sha256 = "0p96bnkgfb9s5aw6qkfcy1y49xgkafx1w4i36bf1zd9xwbvjcqjs";
      name = "qtbase-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtcharts-everywhere-src-6.10.1.tar.xz";
      sha256 = "1x1adsv3nnx44y9ldfjrz4nlhacxalsixdklxypqzyvw05w2568p";
      name = "qtcharts-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtconnectivity-everywhere-src-6.10.1.tar.xz";
      sha256 = "1zsl46nbacpkvgma9si39p8k7qhqq3cdwnfw7pij0f67j0xgvbkv";
      name = "qtconnectivity-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtdatavis3d-everywhere-src-6.10.1.tar.xz";
      sha256 = "01xva2m5x71avdqzp48zlq57l8v7kishzg75iwjjbrbazpx7q730";
      name = "qtdatavis3d-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtdeclarative-everywhere-src-6.10.1.tar.xz";
      sha256 = "0gl4akd7p0g6sf0y234lwkxvr16njjbxc19maj465fg0jjwfzd2g";
      name = "qtdeclarative-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtdoc-everywhere-src-6.10.1.tar.xz";
      sha256 = "16h90yp34yn17z56y570yldl287glfasq4ayci7sk09jpd5n39h3";
      name = "qtdoc-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtgraphs-everywhere-src-6.10.1.tar.xz";
      sha256 = "0vjpbv7ck5p8z38j9a70a6kgsjvfx432lvh5slmbgim33yra0ksd";
      name = "qtgraphs-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtgrpc-everywhere-src-6.10.1.tar.xz";
      sha256 = "0zspyhlhl4irwrr4vm4pg3mppyybyw0q76zlgvpj4j9wcfw8y4wq";
      name = "qtgrpc-everywhere-src-6.10.1.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qthttpserver-everywhere-src-6.10.1.tar.xz";
      sha256 = "0fz98hczfkkrhjmkwxi7159zpal4wvv5sb2y8pid9d2bsfb8sv52";
      name = "qthttpserver-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtimageformats-everywhere-src-6.10.1.tar.xz";
      sha256 = "0wksip3a9xszlkq6368fdkz60qszfqy3wawl13w9dnw14ggsp3j9";
      name = "qtimageformats-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtlanguageserver-everywhere-src-6.10.1.tar.xz";
      sha256 = "0v2m18bbm82n9lhb0lxabqnsabfh2nga8a8yndrncmad9xmm4q1k";
      name = "qtlanguageserver-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtlocation = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtlocation-everywhere-src-6.10.1.tar.xz";
      sha256 = "02agg502pkdqgl3156al26bn4ascgyjz6ybsd7b53p4wp7qii5ib";
      name = "qtlocation-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtlottie-everywhere-src-6.10.1.tar.xz";
      sha256 = "1hjp0hml4cih3vk9dgn3cs94klp7q2di29cdk457jva890y3d75w";
      name = "qtlottie-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtmultimedia-everywhere-src-6.10.1.tar.xz";
      sha256 = "1f371qrcf9rp384niqxqfx0wa01m7p5hv7rjyzwz1m2052ygk97p";
      name = "qtmultimedia-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtnetworkauth-everywhere-src-6.10.1.tar.xz";
      sha256 = "039qrymh18as1ksch470mzrxixr3fry2jnkrs7bqin3jh5cynd8l";
      name = "qtnetworkauth-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtpositioning-everywhere-src-6.10.1.tar.xz";
      sha256 = "08xy8rzm86b55pr8hk1g5rym7y0kblk0wj121l4rzqyn3gpi3cxb";
      name = "qtpositioning-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtquick3d-everywhere-src-6.10.1.tar.xz";
      sha256 = "1rh3wi6pxahdpzlnxw8xrxfx5l931k7kncv03fvxmw6fprr05m0p";
      name = "qtquick3d-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtquick3dphysics-everywhere-src-6.10.1.tar.xz";
      sha256 = "1vigiln79xy6xgr00wgmbfngqqpv6wsr5pviww8yfvmyy5yq8wyr";
      name = "qtquick3dphysics-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtquickeffectmaker-everywhere-src-6.10.1.tar.xz";
      sha256 = "1jdc2bgkrk1kl72h2cjb6j8p9pd2p7ck0zbw9afgam2hqm69hdih";
      name = "qtquickeffectmaker-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtquicktimeline-everywhere-src-6.10.1.tar.xz";
      sha256 = "1dsiwbvd5gqlwm87s05w4qb20731sxqmlm724kisqaf2nj4x4bl8";
      name = "qtquicktimeline-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtremoteobjects-everywhere-src-6.10.1.tar.xz";
      sha256 = "03cakd52p33qi8cjn9zjjmympjd74bc2fsk22cyy6064wbdmd7kw";
      name = "qtremoteobjects-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtscxml-everywhere-src-6.10.1.tar.xz";
      sha256 = "0s8q7873bklgd19ynwil0fxi03m0b7wbx39z07iqim66skjs0rzb";
      name = "qtscxml-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtsensors-everywhere-src-6.10.1.tar.xz";
      sha256 = "15dkhkb6hfybzy4wib3w2bzjqmkymi7fzb7wdmq8jii36gh9rkj9";
      name = "qtsensors-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtserialbus-everywhere-src-6.10.1.tar.xz";
      sha256 = "1m9ymfggv3l8lj7ji6kgayr5x6cisi20r3ikasbsbpzjgbvzqf95";
      name = "qtserialbus-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtserialport-everywhere-src-6.10.1.tar.xz";
      sha256 = "0k2c1zbx20mcrn6hkcnsxy1252g1ycjh3mszqyh8axzn6n2gdchp";
      name = "qtserialport-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtshadertools-everywhere-src-6.10.1.tar.xz";
      sha256 = "1djvynddqksxnbb94m2pvf1ngkdqc8631xa61nnkvdaj6fk98y5n";
      name = "qtshadertools-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtspeech = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtspeech-everywhere-src-6.10.1.tar.xz";
      sha256 = "0kvzic83d98szj6scgkm6hhj1p6jgr3i17c1523dw43f1xafrjj2";
      name = "qtspeech-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtsvg-everywhere-src-6.10.1.tar.xz";
      sha256 = "07xh78s2krgnhvdsysf2ji5dicmfns4g92v2990czfzkb1d3aby0";
      name = "qtsvg-everywhere-src-6.10.1.tar.xz";
    };
  };
  qttools = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qttools-everywhere-src-6.10.1.tar.xz";
      sha256 = "16yl0hj540bnf1c1w4h7ph6s6bk15f0mqc1638807spzh21l0j41";
      name = "qttools-everywhere-src-6.10.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qttranslations-everywhere-src-6.10.1.tar.xz";
      sha256 = "0513kpwmsmmk85rwzh77nkmmgkwi58kvvrws8xm3fb51i3gs4jcf";
      name = "qttranslations-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtvirtualkeyboard-everywhere-src-6.10.1.tar.xz";
      sha256 = "1pxnp4lg6i3v57ynqvisljp3dmfcjpp6q0dr0av03g5gi0qxx72v";
      name = "qtvirtualkeyboard-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtwayland-everywhere-src-6.10.1.tar.xz";
      sha256 = "04yb4x7k0dv4m7j6qagvgxz2k08yvl1msk0zjwn6nyi202w6vgs9";
      name = "qtwayland-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtwebchannel-everywhere-src-6.10.1.tar.xz";
      sha256 = "049iv4vhzx061ka5skz2803npjsb477c20nfxxc0zrihy8jnk8bv";
      name = "qtwebchannel-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtwebengine-everywhere-src-6.10.1.tar.xz";
      sha256 = "1qyix9wbb2k96ybfavl56ffh3s6kbkfswvv5irmrlhm0hrhymdbp";
      name = "qtwebengine-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtwebsockets-everywhere-src-6.10.1.tar.xz";
      sha256 = "00dxjl3zr2vgj374vd31frnp8sxxknl3pmw46cxv3qhq8klwfai7";
      name = "qtwebsockets-everywhere-src-6.10.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.10.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.1/submodules/qtwebview-everywhere-src-6.10.1.tar.xz";
      sha256 = "0vvgn95bkrisjqwml16964zk0r9s6qvc6g81anl69xbs7mc80422";
      name = "qtwebview-everywhere-src-6.10.1.tar.xz";
    };
  };
}
