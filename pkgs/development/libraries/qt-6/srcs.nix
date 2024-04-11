# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6/
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qt3d-everywhere-src-6.6.3.tar.xz";
      sha256 = "0v6zprw9r4z4inj7mg364n959c6japklm7ji2952nm3i01zp8jd5";
      name = "qt3d-everywhere-src-6.6.3.tar.xz";
    };
  };
  qt5compat = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qt5compat-everywhere-src-6.6.3.tar.xz";
      sha256 = "02zcrrh6rq5p6bqix5nk2h22rfqdrf4d0h7y4rva5zmbbr7czhk8";
      name = "qt5compat-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtactiveqt-everywhere-src-6.6.3.tar.xz";
      sha256 = "0balhrmzmjrqn6h2r3rr00776vxhdpqzwhk9knrlvix8i1kr86x1";
      name = "qtactiveqt-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtbase = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtbase-everywhere-src-6.6.3.tar.xz";
      sha256 = "0qklvzg242ilxw29jd2vsz6s8ni4dpraf4ghfa4dykhc705zv4q4";
      name = "qtbase-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtcharts = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtcharts-everywhere-src-6.6.3.tar.xz";
      sha256 = "1rbz2nm8wrdf060cssvs69b5kqv0ybxjqw1clm5mdllg2j38i5jh";
      name = "qtcharts-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtconnectivity-everywhere-src-6.6.3.tar.xz";
      sha256 = "066mf4d6a81ywviwr8bvm1mpm2ykjzysvcc0v2x82h5bl28vl6h9";
      name = "qtconnectivity-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtdatavis3d-everywhere-src-6.6.3.tar.xz";
      sha256 = "1gyz83hkmjin3fr3brg00qchbb0awprwx99idysrc6chckj825wv";
      name = "qtdatavis3d-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtdeclarative-everywhere-src-6.6.3.tar.xz";
      sha256 = "1wwjlwjb3hnlpai4rrrdsm096a6ahb1izs3524r79jpjzhn7n805";
      name = "qtdeclarative-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtdoc = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtdoc-everywhere-src-6.6.3.tar.xz";
      sha256 = "1j7awdbg7c0slbyhld8cdbx4dic7hhqv3g1qka809bjcxa2hb188";
      name = "qtdoc-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtgraphs-everywhere-src-6.6.3.tar.xz";
      sha256 = "1ppdas6bl22z69w8wdy7xl0f1kyqja2gwjd4cn6kjmsslws5rhi2";
      name = "qtgraphs-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtgrpc-everywhere-src-6.6.3.tar.xz";
      sha256 = "11q9cqqk8bs3k6n5pxys2r4fisbs3xvv8d8lsi7wm25rqh5qv1kj";
      name = "qtgrpc-everywhere-src-6.6.3.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qthttpserver-everywhere-src-6.6.3.tar.xz";
      sha256 = "0dbqx36ywfmqi4nxfi4dl17scj9nkl8sbpb670ffy3nh8pbpib21";
      name = "qthttpserver-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtimageformats-everywhere-src-6.6.3.tar.xz";
      sha256 = "0z328i6fix1qdklfbs1w4dsr64zavjj5kzqvzipww0v62xhfm99w";
      name = "qtimageformats-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtlanguageserver-everywhere-src-6.6.3.tar.xz";
      sha256 = "136gyvkzm6skdv5yhyy4nqhbczfc2mn4nbr9hvpkpljb0awv888h";
      name = "qtlanguageserver-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtlocation = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtlocation-everywhere-src-6.6.3.tar.xz";
      sha256 = "1l81z3zq1zg015l6qxx4yzssdspw689m9bpzxp23yshaych2kd6p";
      name = "qtlocation-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtlottie = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtlottie-everywhere-src-6.6.3.tar.xz";
      sha256 = "1d0fjb0080wnd71f50zwal1b504iimln9mpnb3sc5yznmv8gm4cq";
      name = "qtlottie-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtmultimedia-everywhere-src-6.6.3.tar.xz";
      sha256 = "1ciswpv8p71j9hwwdhfr5pmsrnizlaijp0dnyc99lk5is8qgh05y";
      name = "qtmultimedia-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtnetworkauth-everywhere-src-6.6.3.tar.xz";
      sha256 = "153mpg4hv3nclcdrkbzkalg4xf5k6r64fj003b725zyp885s7fax";
      name = "qtnetworkauth-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtpositioning-everywhere-src-6.6.3.tar.xz";
      sha256 = "1frzzndsscb6iqschklks2l17ppnjpnx1lq1cypnq3x0598bcdws";
      name = "qtpositioning-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtquick3d-everywhere-src-6.6.3.tar.xz";
      sha256 = "1qls5cydhm7p1g3gqzvnism8k0h6wjzi8x12gn51dapvnzq2cxlr";
      name = "qtquick3d-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtquick3dphysics-everywhere-src-6.6.3.tar.xz";
      sha256 = "0ipma4qdmzyyajs5inp7d3znh2hfx42gia7x9ahqpb515r49pqb7";
      name = "qtquick3dphysics-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtquickeffectmaker-everywhere-src-6.6.3.tar.xz";
      sha256 = "0mr350c9kj74g48lavq5z5c604cdgcyycfdpwv5z8bmbr49jl95w";
      name = "qtquickeffectmaker-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtquicktimeline-everywhere-src-6.6.3.tar.xz";
      sha256 = "0b266w7al90fbbp16w506klba50d4izf6nfcmmp5fpr6h5pxvcyk";
      name = "qtquicktimeline-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtremoteobjects-everywhere-src-6.6.3.tar.xz";
      sha256 = "16bd4zd3yfzlzk087qphphsh8hv38q3a57n1yknvkc5fchzmfzjz";
      name = "qtremoteobjects-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtscxml = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtscxml-everywhere-src-6.6.3.tar.xz";
      sha256 = "1dbcw4qnss5rif97gdcimyzl3jqa508yph611dvvhc1xn16nl6qg";
      name = "qtscxml-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtsensors = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtsensors-everywhere-src-6.6.3.tar.xz";
      sha256 = "0r9p3lm159pji29vq9kii42jkz4rg15hqh6zlq9442i58a0ayddj";
      name = "qtsensors-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtserialbus-everywhere-src-6.6.3.tar.xz";
      sha256 = "1yyh1bh5pjlilcq84fgfw6wd0jak55wndwf0sn92lbhsp3y5lghl";
      name = "qtserialbus-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtserialport = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtserialport-everywhere-src-6.6.3.tar.xz";
      sha256 = "0dywalgafvxi2jgdv9dk22hwwd8qsgk5xfybh75n3njmwmwnarg1";
      name = "qtserialport-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtshadertools-everywhere-src-6.6.3.tar.xz";
      sha256 = "1rm17hyhq244zskq3ar3h22qjd5dshy84nnyq1ivhg5k7gb0j2cc";
      name = "qtshadertools-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtspeech = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtspeech-everywhere-src-6.6.3.tar.xz";
      sha256 = "1yh3r5zbhgwkjgs7yk6iv2w23766n1i4z8vjkkw5awdixx3gfa76";
      name = "qtspeech-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtsvg = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtsvg-everywhere-src-6.6.3.tar.xz";
      sha256 = "1ir57bis27whq7bwqykk1qlxy0522k4ia39brxayjmfadrbixjsa";
      name = "qtsvg-everywhere-src-6.6.3.tar.xz";
    };
  };
  qttools = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qttools-everywhere-src-6.6.3.tar.xz";
      sha256 = "1h0vz46mpvzbm5w6sgpk0b3mqkn278l45arhxxk41dwc5n14qvda";
      name = "qttools-everywhere-src-6.6.3.tar.xz";
    };
  };
  qttranslations = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qttranslations-everywhere-src-6.6.3.tar.xz";
      sha256 = "1kvkrwbgby4i69dpxbxxcv0qbsz69n6icpyr4wcf8qm2r4m5zqqj";
      name = "qttranslations-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtvirtualkeyboard-everywhere-src-6.6.3.tar.xz";
      sha256 = "0d517x60birlf8xb3sphchvgm235f8q1868q98kg76plzfhq57wq";
      name = "qtvirtualkeyboard-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtwayland = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtwayland-everywhere-src-6.6.3.tar.xz";
      sha256 = "0gamcqpl302wlznfnlcg9vlnnhfpxgjnz05prwc9wpy0xh7wqvm9";
      name = "qtwayland-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtwebchannel-everywhere-src-6.6.3.tar.xz";
      sha256 = "0cwcf4pri901piyj0lvqmks9l84di9rcafnfgrmgg5mls7jjlyvw";
      name = "qtwebchannel-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtwebengine-everywhere-src-6.6.3.tar.xz";
      sha256 = "016qvbmdja2abajvsznnjdvblrmzgvs8s2dzlxws30hvna1xqavw";
      name = "qtwebengine-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtwebsockets-everywhere-src-6.6.3.tar.xz";
      sha256 = "0dm066lv3n97ril9iyd5xn8j13m6r7xp844aagj6dpclaxv83x0n";
      name = "qtwebsockets-everywhere-src-6.6.3.tar.xz";
    };
  };
  qtwebview = {
    version = "6.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.3/submodules/qtwebview-everywhere-src-6.6.3.tar.xz";
      sha256 = "00jcxzi9wcbviscn5y0h0mkbac88lpjammg3zvfvjih7avgn6r10";
      name = "qtwebview-everywhere-src-6.6.3.tar.xz";
    };
  };
}
