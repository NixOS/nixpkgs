# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qt3d-everywhere-src-6.5.2.tar.xz";
      sha256 = "047rwawrlm7n0vifxmsqvs3w3j5c16x8qkpx8xazq6xd47dn9w11";
      name = "qt3d-everywhere-src-6.5.2.tar.xz";
    };
  };
  qt5 = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qt5-everywhere-src-6.5.2.tar.xz";
      sha256 = "15da8xd213fg2yfna3zvvr5mnhdfdai0i4m1paqfxr10sl81p515";
      name = "qt5-everywhere-src-6.5.2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qt5compat-everywhere-src-6.5.2.tar.xz";
      sha256 = "1i4izabbmf1dayzlj1miz7hsm4cy0qb7i72pwyl2fp05w8pf9axr";
      name = "qt5compat-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtactiveqt-everywhere-src-6.5.2.tar.xz";
      sha256 = "04zhbwhnjlc561bs2f4y82mzlf18byy6g5gh37yq9r3gfz54002x";
      name = "qtactiveqt-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtbase = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtbase-everywhere-src-6.5.2.tar.xz";
      sha256 = "0s8jwzdcv97dfy8n3jjm8zzvllv380l73mwdva7rs2nqnhlwgd1x";
      name = "qtbase-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtcharts-everywhere-src-6.5.2.tar.xz";
      sha256 = "0bddlrwda5bh5bdwdx86ixdpm3zg5nygzb754y5nkjlw06zgfnkp";
      name = "qtcharts-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtconnectivity-everywhere-src-6.5.2.tar.xz";
      sha256 = "16fwbz9pr6pi19119mp6w0crq9nsb35fw8cgpfpkq99d6li4jbnv";
      name = "qtconnectivity-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtdatavis3d-everywhere-src-6.5.2.tar.xz";
      sha256 = "1s8wlpc4nibnxaghkxmaxda5dkkn64jw6qgmzw39vi5vvhc3khb8";
      name = "qtdatavis3d-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtdeclarative-everywhere-src-6.5.2.tar.xz";
      sha256 = "06c7xfqn2a5s2m8j1bcvx3pyjqg1rgqkjvp49737gb4z9vjiz8gk";
      name = "qtdeclarative-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtdoc-everywhere-src-6.5.2.tar.xz";
      sha256 = "0cydg39f4cpv965pr97qn3spm5fzlxvhamifjfdsrzgskc5nm0v3";
      name = "qtdoc-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtgrpc-everywhere-src-6.5.2.tar.xz";
      sha256 = "016jw2ny7paky54pk4pa499273919s8ag2ksx361ir6d0ydrdcks";
      name = "qtgrpc-everywhere-src-6.5.2.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qthttpserver-everywhere-src-6.5.2.tar.xz";
      sha256 = "1b6w0999n5vw5xb93m0rc896l6ci3jld657y8645rl3q29fjpypq";
      name = "qthttpserver-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtimageformats-everywhere-src-6.5.2.tar.xz";
      sha256 = "0hv7mkn72126rkhy5gmjmbvzy7v17mkk3q2pkmzy99f64j4w1q5a";
      name = "qtimageformats-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtlanguageserver-everywhere-src-6.5.2.tar.xz";
      sha256 = "196iicwpqca2ydpca41qs6aqxxq8ycknw6lm2v00h1w3m86frdbk";
      name = "qtlanguageserver-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtlocation = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtlocation-everywhere-src-6.5.2.tar.xz";
      sha256 = "1yvdv1gqj7dij7v4cq9rlnqfb77c0v9b7n56jccvy5v6q9j7s7c9";
      name = "qtlocation-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtlottie-everywhere-src-6.5.2.tar.xz";
      sha256 = "16z8fhaa40ig0cggb689zf8j3cid6fk6pmh91b8342ymy1fdqfh0";
      name = "qtlottie-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtmultimedia-everywhere-src-6.5.2.tar.xz";
      sha256 = "0xc9k4mlncscxqbp8q46yjd89k4jb8j0ggbi5ad874lycym013wl";
      name = "qtmultimedia-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtnetworkauth-everywhere-src-6.5.2.tar.xz";
      sha256 = "0g18kh3zhcfi9ni8cqbbjdc1l6jf99ijv5shcl42jk6219b4pk2f";
      name = "qtnetworkauth-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtpositioning-everywhere-src-6.5.2.tar.xz";
      sha256 = "1yhlfs8izc054qv1krf5qv6zzjlvmz013h74fwamn74dfh1kyjbh";
      name = "qtpositioning-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtquick3d-everywhere-src-6.5.2.tar.xz";
      sha256 = "1nh0vg2m1lf8m40bxbwsam5pwdzjammhal69k2pb5s0rjifs7q3m";
      name = "qtquick3d-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtquick3dphysics-everywhere-src-6.5.2.tar.xz";
      sha256 = "0dri8v0pmvc1h1cdhdchvd4xi5f62c1wrk0jd01lh95i6sc1403m";
      name = "qtquick3dphysics-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtquickeffectmaker-everywhere-src-6.5.2.tar.xz";
      sha256 = "1gvcszqj6khqisxkpwi67xad0247hpq5zcz4v2vhbgkxq8kwfiym";
      name = "qtquickeffectmaker-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtquicktimeline-everywhere-src-6.5.2.tar.xz";
      sha256 = "1fhmy01nqcr9q1193m9fkhbvqd9208kaigprqxkjjm61bn8awif9";
      name = "qtquicktimeline-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtremoteobjects-everywhere-src-6.5.2.tar.xz";
      sha256 = "0k29sk02n54vj1w6vh6xycsjpyfqlijc13fnxh1q7wpgg4gizx60";
      name = "qtremoteobjects-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtscxml-everywhere-src-6.5.2.tar.xz";
      sha256 = "1jxx9p7zi40r990ky991xd43mv6i8hdpnj2fhl7sf4q9fpng4c58";
      name = "qtscxml-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtsensors-everywhere-src-6.5.2.tar.xz";
      sha256 = "19iamfl4znqbfflnnpis6qk3cqri7kzbg0nsgf42lc5lzdybs1j0";
      name = "qtsensors-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtserialbus-everywhere-src-6.5.2.tar.xz";
      sha256 = "1zndnw1zx5x9daidcm0jq7jcr06ihw0nf6iksrx591f1rl3n6hph";
      name = "qtserialbus-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtserialport-everywhere-src-6.5.2.tar.xz";
      sha256 = "17nc5kmha6fy3vzkxfr2gxyzdsahs1x66d5lhcqk0szak8b58g06";
      name = "qtserialport-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtshadertools-everywhere-src-6.5.2.tar.xz";
      sha256 = "0g8aziqhds2fkx11y4p2akmyn2p1qqf2fjxv72f9pibnhpdv0gya";
      name = "qtshadertools-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtspeech = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtspeech-everywhere-src-6.5.2.tar.xz";
      sha256 = "1cnlc9x0wswzl7j2imi4kvs9zavs4z1mhzzfpwr6d9zlfql9rzw8";
      name = "qtspeech-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtsvg-everywhere-src-6.5.2.tar.xz";
      sha256 = "18v337lfk8krg0hff5jx6fi7gn6x3djn03x3psrhlbmgjc8crd28";
      name = "qtsvg-everywhere-src-6.5.2.tar.xz";
    };
  };
  qttools = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qttools-everywhere-src-6.5.2.tar.xz";
      sha256 = "0ha3v488vnm4pgdpyjgf859sak0z2fwmbgcyivcd93qxflign7sm";
      name = "qttools-everywhere-src-6.5.2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qttranslations-everywhere-src-6.5.2.tar.xz";
      sha256 = "1sxy2ljn5ajvn4yjb8fx86l56viyvqh5r9hf5x67azkmgrilaz1k";
      name = "qttranslations-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtvirtualkeyboard-everywhere-src-6.5.2.tar.xz";
      sha256 = "0sb2c901ma30dcbf4yhznw0pad09iz55alvkzyw2d992gqwf0w05";
      name = "qtvirtualkeyboard-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtwayland-everywhere-src-6.5.2.tar.xz";
      sha256 = "16iwar19sgjvxgmbr6hmd3hsxp6ahdjwl1lra2wapl3zzf3bw81h";
      name = "qtwayland-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtwebchannel-everywhere-src-6.5.2.tar.xz";
      sha256 = "0qwfnwva7v5f2g5is17yy66mnmc9c1yf9aagaw5qanskdvxdk261";
      name = "qtwebchannel-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtwebengine-everywhere-src-6.5.2.tar.xz";
      sha256 = "17qxf3asyxq6kcqqvml170n7rnzih3nr4srp9r5v80pmas5l7jg7";
      name = "qtwebengine-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtwebsockets-everywhere-src-6.5.2.tar.xz";
      sha256 = "0xjwifxj2ssshys6f6kjr6ri2vq1wfshxky6mcscjm7vvyqdfjr0";
      name = "qtwebsockets-everywhere-src-6.5.2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.5.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.2/submodules/qtwebview-everywhere-src-6.5.2.tar.xz";
      sha256 = "0cgn1px8zk2khmswi9zawi9cnx9p26y4lb3a0kr4kfklm1rf00jr";
      name = "qtwebview-everywhere-src-6.5.2.tar.xz";
    };
  };
}
