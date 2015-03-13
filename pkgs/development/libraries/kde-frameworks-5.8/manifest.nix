# This file is generated automatically. DO NOT EDIT!
{ stdenv, fetchurl, mirror }:
[
  {
    name = stdenv.lib.nameFromURL "kpackage-5.8.0.tar.xz" ".tar";
    store = "/nix/store/pr2pj0xx1xnxh3bz3zz5zymmmjfvdwks-kpackage-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kpackage-5.8.0.tar.xz";
      sha256 = "1y4y8q5dvny00gyk5sgnack612jkpq8xlq899vp0821wf4df0r1a";
      name = "kpackage-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdesu-5.8.0.tar.xz" ".tar";
    store = "/nix/store/jwyz61xs4nl22wb1yahyq5kliqq1idsm-kdesu-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kdesu-5.8.0.tar.xz";
      sha256 = "0bwxhg3bcha94k8bnlsmk0cadpx1aiyrsnzw2ivwswm2nyx1dv3v";
      name = "kdesu-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kcoreaddons-5.8.0.tar.xz" ".tar";
    store = "/nix/store/7pg9x6wg9j16fqv9n8dhypriqpcssfsz-kcoreaddons-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kcoreaddons-5.8.0.tar.xz";
      sha256 = "0msh83vqprl8lcm1z0jj4gpn2mrfrxrsf9w3dm4l66x0fh972w0f";
      name = "kcoreaddons-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "sonnet-5.8.0.tar.xz" ".tar";
    store = "/nix/store/353pfvh6mzhfkkd3w5fys3s4cabmcq51-sonnet-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/sonnet-5.8.0.tar.xz";
      sha256 = "09faq7j3f5divzpjfz103i0sih53fxnywfdbh1yg1wpf53afs1q7";
      name = "sonnet-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kactivities-5.8.0.tar.xz" ".tar";
    store = "/nix/store/ik33fvbzj7arr9380jig3id3dadjspid-kactivities-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kactivities-5.8.0.tar.xz";
      sha256 = "0jk3kmpsqv0bj7885lfiiwnhxw7vvqqpxnm774s946qgsbscbzsa";
      name = "kactivities-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kio-5.8.0.tar.xz" ".tar";
    store = "/nix/store/vamd45ddai43sz2r6hqzp7mjvqa87273-kio-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kio-5.8.0.tar.xz";
      sha256 = "08gzsnqfc8ql6183im21w3kb1x41gkxp5rbm9b1xj4sh2bjv12ba";
      name = "kio-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "knotifications-5.8.0.tar.xz" ".tar";
    store = "/nix/store/dxdpmbwhjn7dvs364shhzdx9ckpn8sbc-knotifications-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/knotifications-5.8.0.tar.xz";
      sha256 = "06wvwqprq7nr33jm0lcdzgf2nqaqcdq3h353pqqhx100b7j81pvq";
      name = "knotifications-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kinit-5.8.0.tar.xz" ".tar";
    store = "/nix/store/m7m2cqs903l80zdd4sdgjkx9hph8d14b-kinit-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kinit-5.8.0.tar.xz";
      sha256 = "058rd6n29jkx0fwgg76mnnhddpppby3ap1yaq3sivik5mk4dc2hk";
      name = "kinit-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kitemmodels-5.8.0.tar.xz" ".tar";
    store = "/nix/store/qhv3rm3j022bqjpz5nwqjvxnkjg8zvsv-kitemmodels-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kitemmodels-5.8.0.tar.xz";
      sha256 = "1m6pgm91baaqqf9vr1z5g649v2dzgms0k8rmq64c2bsp2s58y0gj";
      name = "kitemmodels-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kbookmarks-5.8.0.tar.xz" ".tar";
    store = "/nix/store/192py0w7pzw5zq2536p1dg5wyk2cw520-kbookmarks-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kbookmarks-5.8.0.tar.xz";
      sha256 = "0brlaim5ja8r9car3yjfsv1aw3g5309x3q0c3c6xhm5wchziyqqi";
      name = "kbookmarks-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kguiaddons-5.8.0.tar.xz" ".tar";
    store = "/nix/store/mwnyb1bm3vvzn9qlsb3r4m3my9mynirr-kguiaddons-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kguiaddons-5.8.0.tar.xz";
      sha256 = "11d0panxgk02zvanp8pfy9kap3qg9myasanzly1dd1xyvqvdv8w2";
      name = "kguiaddons-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kglobalaccel-5.8.0.tar.xz" ".tar";
    store = "/nix/store/f2r6rdwgpgcz9hclwpv5pjfy3mv8slmc-kglobalaccel-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kglobalaccel-5.8.0.tar.xz";
      sha256 = "0fw2si9zdq2nigjavfdy0ncwlxzra2wkdl84kyirwnm4mqvwwym4";
      name = "kglobalaccel-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kauth-5.8.0.tar.xz" ".tar";
    store = "/nix/store/vvfki2y80hbgly49w4j2j3kv8zjxgg8m-kauth-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kauth-5.8.0.tar.xz";
      sha256 = "1vzrafk13w2fyz1qz2xdkm60ajalbkky1ji9jn6bs5dhkywmfzqv";
      name = "kauth-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kwallet-5.8.0.tar.xz" ".tar";
    store = "/nix/store/fy65566wbdry47fq4vm5ip4zdyraskch-kwallet-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kwallet-5.8.0.tar.xz";
      sha256 = "1hwdfjh86calyq8y86n34ybgzadhx1xw9vpzkmkrdjaqkxd67jy8";
      name = "kwallet-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "solid-5.8.0.tar.xz" ".tar";
    store = "/nix/store/6k08mkbmg1dk1ckljjl2r6mrn20zivyq-solid-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/solid-5.8.0.tar.xz";
      sha256 = "07qjih5gla2y4a59x4jb25r00hr0wsk12cs5gbwd9vi5y0345yq3";
      name = "solid-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kidletime-5.8.0.tar.xz" ".tar";
    store = "/nix/store/zvb2yl00v66ra6p88hg90v2n7h0xlkga-kidletime-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kidletime-5.8.0.tar.xz";
      sha256 = "0bnhpsrf2bs08p9hjv254mxch2gnvv28pp9ab3bfp7crdj5dbrvy";
      name = "kidletime-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kplotting-5.8.0.tar.xz" ".tar";
    store = "/nix/store/aicz3im9y74y3n0pw7pfqmwks6v1qckb-kplotting-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kplotting-5.8.0.tar.xz";
      sha256 = "15iifzwq9ldimdl1fq4ns2lagmhqyciyi8ycwp7zhwz2a4yga1xi";
      name = "kplotting-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kparts-5.8.0.tar.xz" ".tar";
    store = "/nix/store/f30idimxzr7vn9x4xqf1q4dnq4xkybi2-kparts-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kparts-5.8.0.tar.xz";
      sha256 = "009qrz8x9j12rsr678yp0n4m61k2vqgpg2x0n4z0jnzl4hp8g4b2";
      name = "kparts-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdnssd-5.8.0.tar.xz" ".tar";
    store = "/nix/store/lq5gs7qa5jbzql3d90ny0ns9kvwn5nxq-kdnssd-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kdnssd-5.8.0.tar.xz";
      sha256 = "0z8ssaxfff1ay9q0l3cp221nvnlg1vypd4ms8zdw7vglyzg3cvvg";
      name = "kdnssd-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "karchive-5.8.0.tar.xz" ".tar";
    store = "/nix/store/hplgp8rl8y132ngmb55b357nn18x9684-karchive-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/karchive-5.8.0.tar.xz";
      sha256 = "0cjwzmj4h6kf8ip4iy0vx97y49nkj0m68rgmwdp5w6wl9qsdymyr";
      name = "karchive-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kded-5.8.0.tar.xz" ".tar";
    store = "/nix/store/hah2vldmgkvzxbrzfv5dwfg9wnf5k04r-kded-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kded-5.8.0.tar.xz";
      sha256 = "18d8alv96i8a00rrylc19f7sc862zzrk5hk0dryyqyca7i4is0sv";
      name = "kded-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kconfigwidgets-5.8.0.tar.xz" ".tar";
    store = "/nix/store/s3vfmb8y5r9ks3br1plpahg3mccxkwb3-kconfigwidgets-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kconfigwidgets-5.8.0.tar.xz";
      sha256 = "08kvg4idmy6h2r49h9zl4s5qm18283i61vk7j9ajpzs2wj8f0yq9";
      name = "kconfigwidgets-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kpty-5.8.0.tar.xz" ".tar";
    store = "/nix/store/zr8y35s1abk00d072i3wh0lrra7j9miv-kpty-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kpty-5.8.0.tar.xz";
      sha256 = "0ycx73hxf257sc77x597a888ngrv9kw23qrv15pk40k4s9r927wj";
      name = "kpty-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kwidgetsaddons-5.8.0.tar.xz" ".tar";
    store = "/nix/store/jnph6s99cfp9b1akfw7zg73jm0sjngqp-kwidgetsaddons-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kwidgetsaddons-5.8.0.tar.xz";
      sha256 = "0ay4fxijmaxqaqkdswwqykq0xi99lj76rqllmn14w1vk60v7kc1c";
      name = "kwidgetsaddons-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kcompletion-5.8.0.tar.xz" ".tar";
    store = "/nix/store/0win9qp98x332z1m2sln9mkqbdiq06jj-kcompletion-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kcompletion-5.8.0.tar.xz";
      sha256 = "13r7zs6rbqx7ylipy8738l7565xi925y12sx8lcbdw7ib0dhz0wb";
      name = "kcompletion-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "frameworkintegration-5.8.0.tar.xz" ".tar";
    store = "/nix/store/m4ra9rcv4jpp60mw0s6ak3zkr1djwncl-frameworkintegration-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/frameworkintegration-5.8.0.tar.xz";
      sha256 = "11sbnfs7wy103v46wxsx9njsjskjdig80chx193wqqqyzbdwgq3f";
      name = "frameworkintegration-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "networkmanager-qt-5.8.0.tar.xz" ".tar";
    store = "/nix/store/88lzs61m9a65p1vhbyyvvqsza4pp8y8n-networkmanager-qt-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/networkmanager-qt-5.8.0.tar.xz";
      sha256 = "07c9n2clsvb152qcxs8mhinmy8hnzhij52xx9pkd0v0az6xmi23z";
      name = "networkmanager-qt-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "plasma-framework-5.8.0.tar.xz" ".tar";
    store = "/nix/store/mp3740pcgh3q2as67vw8cl6pd1mb7d42-plasma-framework-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/plasma-framework-5.8.0.tar.xz";
      sha256 = "1042fn164dx62gqh5fnlcid7vcpv0wqal35c2s5iv89xkpa48x82";
      name = "plasma-framework-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kxmlgui-5.8.0.tar.xz" ".tar";
    store = "/nix/store/b0frky56prbmwk6v8bxgwya2x1hzi01c-kxmlgui-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kxmlgui-5.8.0.tar.xz";
      sha256 = "1l3svzk312fv4zya7fglmy3wajr0dblfff8fdyrlfa6g4qqv0xzg";
      name = "kxmlgui-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kitemviews-5.8.0.tar.xz" ".tar";
    store = "/nix/store/fa4nvdny3ca1a0dw23dv88kq1skwydck-kitemviews-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kitemviews-5.8.0.tar.xz";
      sha256 = "1lryy36bm592kd1jiqxgs7s64bzfnn1mlxhi8cggckvcqc20jyfd";
      name = "kitemviews-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdeclarative-5.8.0.tar.xz" ".tar";
    store = "/nix/store/cnc3mvxf4xhhxffvdv982wya7ab5g13r-kdeclarative-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kdeclarative-5.8.0.tar.xz";
      sha256 = "18yyhw4d3srlddj7ycn0qi6dcjc7hz0ml66fx2a3z8ljafplhf2n";
      name = "kdeclarative-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kimageformats-5.8.0.tar.xz" ".tar";
    store = "/nix/store/s2n2g5ig1wqkyd11n0gc0ch3584k9qby-kimageformats-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kimageformats-5.8.0.tar.xz";
      sha256 = "05nnipfq5qpqnh1drfjlbhz673zd3qi61jdx69vym5khfpxb7vaz";
      name = "kimageformats-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kcodecs-5.8.0.tar.xz" ".tar";
    store = "/nix/store/ll6bzn3mhhf35p8xl32n3wxmcal3dk1i-kcodecs-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kcodecs-5.8.0.tar.xz";
      sha256 = "1ipd85hgm53vv5qhfynzhb2gp6qiz0k4d31ailjm55czrirp02zc";
      name = "kcodecs-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "ktextwidgets-5.8.0.tar.xz" ".tar";
    store = "/nix/store/hkc48gibgnm02ywiddfq6qivwfji988a-ktextwidgets-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/ktextwidgets-5.8.0.tar.xz";
      sha256 = "05aigqfnp1dnrlfba59rr3ccbj06jmjfhja4iz8w3vizxpc2imcv";
      name = "ktextwidgets-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "threadweaver-5.8.0.tar.xz" ".tar";
    store = "/nix/store/r7aa4rhlyqhhrwlbnhgqn0w9nrazbva0-threadweaver-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/threadweaver-5.8.0.tar.xz";
      sha256 = "0fghim7rkdf50sydzsq2q8kr9fkh7ffldn660rf39amggarhnm1c";
      name = "threadweaver-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kwindowsystem-5.8.0.tar.xz" ".tar";
    store = "/nix/store/mgb7hh4a1rc01xfilc9i39h0lc3gvx76-kwindowsystem-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kwindowsystem-5.8.0.tar.xz";
      sha256 = "19caaxzps6fzi9w1k9jcyr1i6qq784q5hfkfvi7pz9aj09f89a65";
      name = "kwindowsystem-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "knewstuff-5.8.0.tar.xz" ".tar";
    store = "/nix/store/z00gzak0za0rvl9n98i074c9vn1ifjhq-knewstuff-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/knewstuff-5.8.0.tar.xz";
      sha256 = "0pjxia7baapbvx7hzmk2rgh08v5n5rd8cfa4mqqz8l7ak7pvaih8";
      name = "knewstuff-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kcrash-5.8.0.tar.xz" ".tar";
    store = "/nix/store/7jz5m4rzrjg2sff80y7mvf62648ynd6r-kcrash-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kcrash-5.8.0.tar.xz";
      sha256 = "02qb16pqdmcx5l5mvi6kxh8q00asq7vd2fp5n8rb8x73354njs2r";
      name = "kcrash-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kpeople-5.8.0.tar.xz" ".tar";
    store = "/nix/store/57l0041ivb40zbx77hcxz0v29argmsx8-kpeople-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kpeople-5.8.0.tar.xz";
      sha256 = "1id2wasxh7him48pnsf6biilakg1hk7by9blylpsxgcj97gzh5h5";
      name = "kpeople-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kunitconversion-5.8.0.tar.xz" ".tar";
    store = "/nix/store/4lf9qjhf0m1c8r36vrs7xgxc61y0kn9m-kunitconversion-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kunitconversion-5.8.0.tar.xz";
      sha256 = "1yhwrbzbsnw9hlbcx0bpivjgwshxy412sds4gg1fkr8iwl53a353";
      name = "kunitconversion-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "ktexteditor-5.8.0.tar.xz" ".tar";
    store = "/nix/store/d14ixg28zc0kvbrj9pyqjzch8vjqvf1k-ktexteditor-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/ktexteditor-5.8.0.tar.xz";
      sha256 = "0hlswklc9h87mj73qm3jdc1hjhrsav58a68rbssmxdzjvq13xz33";
      name = "ktexteditor-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "knotifyconfig-5.8.0.tar.xz" ".tar";
    store = "/nix/store/dbn61n194xfh880pba8dphr5xfxag9lm-knotifyconfig-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/knotifyconfig-5.8.0.tar.xz";
      sha256 = "1i7xcr21mjgd5ys6lhfy939v5sccq445bmjmgm3akwhvj98cm6vm";
      name = "knotifyconfig-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kjobwidgets-5.8.0.tar.xz" ".tar";
    store = "/nix/store/w4fry4a11m0k7agginnj3j9hqjgnad0a-kjobwidgets-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kjobwidgets-5.8.0.tar.xz";
      sha256 = "0fv4w6jb0kx7qcm1yqghxqvzk8zi9h91756b99y4201a8i9aiz67";
      name = "kjobwidgets-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kconfig-5.8.0.tar.xz" ".tar";
    store = "/nix/store/bby9kv5kw0spadprnafjyyviqaixbk72-kconfig-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kconfig-5.8.0.tar.xz";
      sha256 = "0l0ah29967jkr1ajv0lzjdk0gb97ypghd01fn0z32a8l6in4k8ql";
      name = "kconfig-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kemoticons-5.8.0.tar.xz" ".tar";
    store = "/nix/store/mkk8jcv0v6qgpj88ngsic033as91bjrb-kemoticons-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kemoticons-5.8.0.tar.xz";
      sha256 = "1c7xjwm99gg8q971wak6qk9xfmd9h365cqazqqkad9sg8ndfg5hj";
      name = "kemoticons-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdbusaddons-5.8.0.tar.xz" ".tar";
    store = "/nix/store/zx9ak27yf54asn5v65bkg7mxczpm852m-kdbusaddons-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kdbusaddons-5.8.0.tar.xz";
      sha256 = "1aq0n05cpvx3zapgirbb8b45sfss148x3yshd9dwa9npqx3irjxi";
      name = "kdbusaddons-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdoctools-5.8.0.tar.xz" ".tar";
    store = "/nix/store/fg02vk213msvki571pnlbcsjc47dh4id-kdoctools-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kdoctools-5.8.0.tar.xz";
      sha256 = "02qvyz102xyfl4qsfnnpdhg0lrwkd0fp95wgbk0zl7lbh261nm0j";
      name = "kdoctools-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kapidox-5.8.0.tar.xz" ".tar";
    store = "/nix/store/xahpr44r52smzx3g71ss475qfyll1zw0-kapidox-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kapidox-5.8.0.tar.xz";
      sha256 = "0l2vl6q67kripg3ajrm4lzxgg2hn18dbrgl5i3s34swg0ay668pr";
      name = "kapidox-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "extra-cmake-modules-1.8.0.tar.xz" ".tar";
    store = "/nix/store/gx034z2gbkgr2kd0kgm0g3yivkmxiqbd-extra-cmake-modules-1.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/extra-cmake-modules-1.8.0.tar.xz";
      sha256 = "0spmfcs94xc4wj42sk599c11yfmy6hg9g8c60cfh8gqyk9527g27";
      name = "extra-cmake-modules-1.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "attica-5.8.0.tar.xz" ".tar";
    store = "/nix/store/6p6grsyj3vlynq2800v1ybz5l2qi2dww-attica-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/attica-5.8.0.tar.xz";
      sha256 = "11fi00x78z7bm60n0gh3025ii1gplkjihgi4x97yjc6bdvr1xigb";
      name = "attica-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdewebkit-5.8.0.tar.xz" ".tar";
    store = "/nix/store/1ylslvzlbn52qszzzb1v5cwbbvj5gk7v-kdewebkit-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kdewebkit-5.8.0.tar.xz";
      sha256 = "1h2qsmbc690apyg9ynff9vc1r3pbpb0369p02gbrn4m6yx40985r";
      name = "kdewebkit-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kiconthemes-5.8.0.tar.xz" ".tar";
    store = "/nix/store/636lwcspq1ndm8q1dcw4yln7ramj59sn-kiconthemes-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kiconthemes-5.8.0.tar.xz";
      sha256 = "0am9kxgwfnknnjnv7pcba55n0rg73lq6wxc5fyv4nz5g2r5c7rb0";
      name = "kiconthemes-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "ki18n-5.8.0.tar.xz" ".tar";
    store = "/nix/store/i7ls6hsr4a91ppnghn5z8hgb1lq2krfz-ki18n-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/ki18n-5.8.0.tar.xz";
      sha256 = "0jlw1bbza0kcnflvpw4nbamqxkj91ij5m31i5kj1kw48sc86l383";
      name = "ki18n-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kcmutils-5.8.0.tar.xz" ".tar";
    store = "/nix/store/78j3wzxv01vgifmrqv8a9xhsamf1cbcv-kcmutils-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kcmutils-5.8.0.tar.xz";
      sha256 = "0zm14mdg5mkczkihgwjwz99wjx30wm6c85dm75yaqhk2d3w1aj9w";
      name = "kcmutils-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kxmlrpcclient-5.8.0.tar.xz" ".tar";
    store = "/nix/store/p9p7sks5g2zxqa9v7lphyk0vzxbrg0h8-kxmlrpcclient-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kxmlrpcclient-5.8.0.tar.xz";
      sha256 = "0xdlz8lvi028h8d13l8zqlbsqqrlpm4x940chxhr92jxlicbhaw3";
      name = "kxmlrpcclient-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kservice-5.8.0.tar.xz" ".tar";
    store = "/nix/store/gjm5i3lpn4h2sfcsjzz4yzm4pw6wzxkj-kservice-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kservice-5.8.0.tar.xz";
      sha256 = "1jk4vh4x7bjr6gqgl118lkkbpmmj1c6y0afysjl9fa45by4bhyz8";
      name = "kservice-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdesignerplugin-5.8.0.tar.xz" ".tar";
    store = "/nix/store/vfjf7vs4sc13dwi21m4ikvr6qwvi1wlg-kdesignerplugin-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/kdesignerplugin-5.8.0.tar.xz";
      sha256 = "18ckgx4dvb4bzy38q0dsi23rp5yqjvynyz2yaisczi0fi4b4zn44";
      name = "kdesignerplugin-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kjs-5.8.0.tar.xz" ".tar";
    store = "/nix/store/5kcpxkfv6l75pad56hk73i2aq6dhm98c-kjs-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/portingAids/kjs-5.8.0.tar.xz";
      sha256 = "0xy51dm8dmdj7rlz1sxyzbwmxyyv0ydhj6mvzk2a2kn1189dl8kz";
      name = "kjs-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kross-5.8.0.tar.xz" ".tar";
    store = "/nix/store/x6zhp5010lwmbp8p0f3dg720iqh8d9xk-kross-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/portingAids/kross-5.8.0.tar.xz";
      sha256 = "15n2gqpxi96p899k8ggals2p9ym1hlksm1kpz7sjk33idljb9972";
      name = "kross-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "krunner-5.8.0.tar.xz" ".tar";
    store = "/nix/store/mxfd3j3r56048khysr8s5p6plw04g3wk-krunner-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/portingAids/krunner-5.8.0.tar.xz";
      sha256 = "0w0s56gaw6s6hiid6dngdgjlr9zzpp9wb6f2v3pk7lg9bxqjwlwh";
      name = "krunner-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kjsembed-5.8.0.tar.xz" ".tar";
    store = "/nix/store/sxjsvg6x6wa0hsblsynnk6y2fp1f876l-kjsembed-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/portingAids/kjsembed-5.8.0.tar.xz";
      sha256 = "04sqva3qngjl73nl1f6mz8np7klbsxp1h6rrqzgln6jd35rzfabx";
      name = "kjsembed-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdelibs4support-5.8.0.tar.xz" ".tar";
    store = "/nix/store/w4s7ij8hj943nkgw9xi6i29hyadlg27i-kdelibs4support-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/portingAids/kdelibs4support-5.8.0.tar.xz";
      sha256 = "0j3jpz7zb1if9x91rz4fr6gny0a9r1c1z9796j0bn7b4frq7l232";
      name = "kdelibs4support-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kmediaplayer-5.8.0.tar.xz" ".tar";
    store = "/nix/store/hbam3379ghcyfw7f34gaqx53s4b92khh-kmediaplayer-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/portingAids/kmediaplayer-5.8.0.tar.xz";
      sha256 = "0ys7q85942fd7cbpyjqj9wcn947v49f22aj64m8s40h7jiwidkpf";
      name = "kmediaplayer-5.8.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "khtml-5.8.0.tar.xz" ".tar";
    store = "/nix/store/ajxcmpx2xzy68ls0ilxiy4hslxmbwpc2-khtml-5.8.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.8/portingAids/khtml-5.8.0.tar.xz";
      sha256 = "0z0123ajf80m99a8kx572nymgmxqrk7svdlja9zrmc9vpbmy643b";
      name = "khtml-5.8.0.tar.xz";
    };
  }
]
