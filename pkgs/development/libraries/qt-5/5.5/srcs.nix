# DO NOT EDIT! This file is generated automatically by manifest.sh
{ fetchurl, mirror }:

{
  qtbase = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtbase-opensource-src-5.5.0.tar.xz";
      sha256 = "0r89axg4vnli0i5s9zxwpcpsdiz12kyx7y2vz0zx204wff8hcgw9";
      name = "qtbase-opensource-src-5.5.0.tar.xz";
    };
  };
  qtsensors = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtsensors-opensource-src-5.5.0.tar.xz";
      sha256 = "0jyiby8q3gyly5sxli4bncs69k1fk0vq9cpkfb4dla2bz6frhnld";
      name = "qtsensors-opensource-src-5.5.0.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtwinextras-opensource-src-5.5.0.tar.xz";
      sha256 = "17kf8hcgr98agr4c5dy3xaifbwzk06ys0qcc6r8s4a40lxpf5vxm";
      name = "qtwinextras-opensource-src-5.5.0.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtxmlpatterns-opensource-src-5.5.0.tar.xz";
      sha256 = "0lzg1j7766bfvhdjd7cp0r6lff7xpzd3q5wrq6p5qg61f3384a37";
      name = "qtxmlpatterns-opensource-src-5.5.0.tar.xz";
    };
  };
  qtwayland = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtwayland-opensource-src-5.5.0.tar.xz";
      sha256 = "0sf8s6vficn7njmrlqcwad1hd3gfhzz84r75h9c53lyys7zkyypa";
      name = "qtwayland-opensource-src-5.5.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtwebchannel-opensource-src-5.5.0.tar.xz";
      sha256 = "139dxdm5kqdf0nbqchvcm70gb6nf9cfn04qv387s6a8bzw28dy4l";
      name = "qtwebchannel-opensource-src-5.5.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtwebsockets-opensource-src-5.5.0.tar.xz";
      sha256 = "1s4axvvqs1ajmb62hg4hyq4c9cckkpvgjfj0vkdxvrninaqnbm0s";
      name = "qtwebsockets-opensource-src-5.5.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtdeclarative-opensource-src-5.5.0.tar.xz";
      sha256 = "0wv7dzlll1k8070kkdriz668hxxg8ka4xv7dh67xlr3pck2i52l5";
      name = "qtdeclarative-opensource-src-5.5.0.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtcanvas3d-opensource-src-5.5.0.tar.xz";
      sha256 = "1is5yikkmps0l03i75r3djgr93nmlbhs6nhawvd4mxrvkwscggj6";
      name = "qtcanvas3d-opensource-src-5.5.0.tar.xz";
    };
  };
  qttools = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qttools-opensource-src-5.5.0.tar.xz";
      sha256 = "0zf0z8r83255m5qximipywldf29p17qn7whfq9b48zzvhxqi8rav";
      name = "qttools-opensource-src-5.5.0.tar.xz";
    };
  };
  qtsvg = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtsvg-opensource-src-5.5.0.tar.xz";
      sha256 = "17z149inv8b83530s0vaas8rj5q7sv011i8pvznsnkfkcvndxvq0";
      name = "qtsvg-opensource-src-5.5.0.tar.xz";
    };
  };
  qt5 = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qt5-opensource-src-5.5.0.tar.xz";
      sha256 = "1rbjrg73lr3782nic5rjpmkx9wacnbw7ql7wxwmsz9fpmpafs267";
      name = "qt5-opensource-src-5.5.0.tar.xz";
    };
  };
  qtscript = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtscript-opensource-src-5.5.0.tar.xz";
      sha256 = "12vyhs6y7c869gg0hmh56hjz5wkmg5dbb7dlv71idjrfigm34f9l";
      name = "qtscript-opensource-src-5.5.0.tar.xz";
    };
  };
  qt3d = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qt3d-opensource-src-5.5.0.tar.xz";
      sha256 = "13jnqg4asik3jkw5csm0p9rl5b31ism7yzyndyyyjygjnvxm8v5z";
      name = "qt3d-opensource-src-5.5.0.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtgraphicaleffects-opensource-src-5.5.0.tar.xz";
      sha256 = "1vj7l7qfqprmdd5ay9p32dfy3cqxbrilhqza9wk7yy8lfi752hzi";
      name = "qtgraphicaleffects-opensource-src-5.5.0.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtmacextras-opensource-src-5.5.0.tar.xz";
      sha256 = "1r4pjcw07j4n110vf3amwbj1x31ncl3h9c5kfampn4fb3b0vjx6j";
      name = "qtmacextras-opensource-src-5.5.0.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtx11extras-opensource-src-5.5.0.tar.xz";
      sha256 = "0ydrs0vdcapbdf2d8sj6pvxj11p0id684c6ywbq53dghr72wxcxw";
      name = "qtx11extras-opensource-src-5.5.0.tar.xz";
    };
  };
  qttranslations = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qttranslations-opensource-src-5.5.0.tar.xz";
      sha256 = "11mzc3403r81krldlmnr9ap07lgqnz67bmvblp6gxjq1w4q1gkjs";
      name = "qttranslations-opensource-src-5.5.0.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtquickcontrols-opensource-src-5.5.0.tar.xz";
      sha256 = "1sn2g3sazd3l3zi8m8a9qdakm9fic44m259iyf97yychnfk6lqfz";
      name = "qtquickcontrols-opensource-src-5.5.0.tar.xz";
    };
  };
  qtwebkit = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtwebkit-opensource-src-5.5.0.tar.xz";
      sha256 = "1v7fv4188rppd1l1nmhdkhlg2x1q9d5shy63n1l0l13x6jb4k5hp";
      name = "qtwebkit-opensource-src-5.5.0.tar.xz";
    };
  };
  qtserialport = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtserialport-opensource-src-5.5.0.tar.xz";
      sha256 = "0rm8xwq7fr6q9gwhqqp3b4y9n7mqhcgr40f9f5dqkhy12chjs3m6";
      name = "qtserialport-opensource-src-5.5.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtmultimedia-opensource-src-5.5.0.tar.xz";
      sha256 = "0nrmhmgwxc1flzg9qnjzpa6qq06gl7x8cskfj2ibnx5dkgaipgx8";
      name = "qtmultimedia-opensource-src-5.5.0.tar.xz";
    };
  };
  qtwebkit-examples = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtwebkit-examples-opensource-src-5.5.0.tar.xz";
      sha256 = "04mxshf730jkmp3cma65vb0m43y8y9y7l31rhbbnmq78avxn8mfj";
      name = "qtwebkit-examples-opensource-src-5.5.0.tar.xz";
    };
  };
  qtquick1 = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtquick1-opensource-src-5.5.0.tar.xz";
      sha256 = "0b7s1pdlbf1a7mz3pkdg7y81nl5s5670lg6majich2v7w4rknmnv";
      name = "qtquick1-opensource-src-5.5.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtwebengine-opensource-src-5.5.0.tar.xz";
      sha256 = "0nnnrcrj0d0ksynsl60zv0z1vq7j123xv6s1lgwq6hkl704fc0yp";
      name = "qtwebengine-opensource-src-5.5.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtactiveqt-opensource-src-5.5.0.tar.xz";
      sha256 = "17nh4gi562cs8rpypvnzld87g407qhxi9gpdcvkjzm4mbhqwa9ql";
      name = "qtactiveqt-opensource-src-5.5.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtimageformats-opensource-src-5.5.0.tar.xz";
      sha256 = "0mc9mxrggnhvvgkl7gf8sp6cn9g5ffhi77krcraxhzavmk9d2yb4";
      name = "qtimageformats-opensource-src-5.5.0.tar.xz";
    };
  };
  qtlocation = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtlocation-opensource-src-5.5.0.tar.xz";
      sha256 = "036bxsjscvwnpy72cvlzv8dday9r76mvpbj9r8fhwhgxakspyb8a";
      name = "qtlocation-opensource-src-5.5.0.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtandroidextras-opensource-src-5.5.0.tar.xz";
      sha256 = "1dnmacpvxrz11nc4hm702p88f1hy5prabvdjx1zwrf55724lc8q2";
      name = "qtandroidextras-opensource-src-5.5.0.tar.xz";
    };
  };
  qtenginio = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtenginio-opensource-src-5.5.0.tar.xz";
      sha256 = "080m3zr5av5bc2gxqyb648hy07jj3rdybkfgh5gcn2sm4qm4n77n";
      name = "qtenginio-opensource-src-5.5.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtconnectivity-opensource-src-5.5.0.tar.xz";
      sha256 = "00j3abhvq9bg4v5z25b7jsr5c2w7hdmnljn875013p0i9s9xvkzi";
      name = "qtconnectivity-opensource-src-5.5.0.tar.xz";
    };
  };
  qtdoc = {
    version = "5.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.0/submodules/qtdoc-opensource-src-5.5.0.tar.xz";
      sha256 = "19vgx1h45g7plj23sckd52npsl8i14fknl5gg103p9xpbq8lw5vz";
      name = "qtdoc-opensource-src-5.5.0.tar.xz";
    };
  };
}
