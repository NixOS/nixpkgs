{ lib
, llvmPackages
, fetchFromGitHub
, fetchFromGitLab
, gmp
, boost
, libelf
, git
, sbcl
, ninja
, pkg-config
, fmt
, ctags
}:

let
  ansi-test = fetchFromGitLab {
    domain = "gitlab.common-lisp.net";
    owner = "yitzchak";
    repo = "ansi-test";
    rev = "33e6391c8d49187918cb2db28155e396017a5151";
    sha256 = "1kaxw4jjqn4yp0wqy98nhxaapmqws4k3nwhryysfzlmniy9ly2ln";
    fetchSubmodules = true;
  };
  cl-bench = fetchFromGitLab {
    domain = "gitlab.common-lisp.net";
    owner = "ansi-test";
    repo = "cl-bench";
    rev = "7d184b4ef2a6272f0e3de88f6c243edb20f7071a";
    sha256 = "1yxl26wf7ybq4hg06k78bh9ws236wywmpsn42kc0rvi3s5c0i4gd";
    fetchSubmodules = true;
  };
  cl-who = fetchFromGitHub {
    owner = "edicl";
    repo = "cl-who";
    rev = "07dafe9b351c32326ce20b5804e798f10d4f273d";
    sha256 = "1rdvs113q6d46cblwhsv1vmm31p952wyzkyibqix0ypadpczlgp5";
  };
  quicklisp-client = fetchFromGitHub {
    owner = "quicklisp";
    repo = "quicklisp-client";
    rev = "version-2021-02-13";
    sha256 = "102f1chpx12h5dcf659a9kzifgfjc482ylf73fg1cs3w34zdawnl";
  };
  shasht = fetchFromGitHub {
    owner = "yitzchak";
    repo = "shasht";
    rev = "4fc7c9dad567a4266ec3a6596d50744df9ea1c61";
    sha256 = "1xpspksfkhk95wjirrqfrqm7sc1wyr2pjw7z25i0qz02rg479hlg";
  };
  trivial-do = fetchFromGitHub {
    owner = "yitzchak";
    repo = "trivial-do";
    rev = "a19f93227cb80a6bec8846655ebcc7998020bd7e";
    sha256 = "0vql7am4zyg6zav3l6n6q3qgdxlnchdxpgdxp8lr9sm7jra7sdsf";
  };
  trivial-gray-streams = fetchFromGitHub {
    owner = "trivial-gray-streams";
    repo = "trivial-gray-streams";
    rev = "2b3823edbc78a450db4891fd2b566ca0316a7876";
    sha256 = "1hipqwwd5ylskybd173rvlsk7ds4w4nq1cmh9952ivm6dgh7pwzn";
  };
  acclimation = fetchFromGitHub {
    owner = "robert-strandh";
    repo = "Acclimation";
    rev = "ff1839faeaaf3bb40775b35174beb9c7dd13ef19";
    sha256 = "04bk389p4fddh4vf9apry4a40ryfhcdf5fq23gh1ihvfdpv3b957";
  };
  alexandria = fetchFromGitLab {
    domain = "gitlab.common-lisp.net";
    owner = "alexandria";
    repo = "alexandria";
    rev = "v1.4";
    sha256 = "0r1adhvf98h0104vq14q7y99h0hsa8wqwqw92h7ghrjxmsvz2z6l";
  };
  anaphora = fetchFromGitHub {
    owner = "spwhitton";
    repo = "anaphora";
    rev = "bcf0f7485eec39415be1b2ec6ca31cf04a8ab5c5";
    sha256 = "1ds5ab0rzkrhfl29xpvmvyxmkdyj9mi19p330pz603lx95njjc0b";
  };
  architecture-builder-protocol = fetchFromGitHub {
    owner = "scymtym";
    repo = "architecture.builder-protocol";
    rev = "fb4e2577ca7787988f09c8ce3f3d3177cd77c9af";
    sha256 = "0nv5wmcf7nvh44148cvq6fvz8zjm212rzzn5r3bi72phpywjxc9v";
  };
  array-utils = fetchFromGitHub {
    owner = "Shinmera";
    repo = "array-utils";
    rev = "5acd90fa3d9703cea33e3825334b256d7947632f";
    sha256 = "1qiw31xxyd73pchim5q9ki012726xvn5ab869qksd1kys7gwgg86";
  };
  babel = fetchFromGitHub {
    owner = "cl-babel";
    repo = "babel";
    rev = "f892d0587c7f3a1e6c0899425921b48008c29ee3";
    sha256 = "04frn19mngvsh8bh7fb1rfjm8mqk8bgzx5c43dg7z02nfsxkqqak";
  };
  bordeaux-threads = fetchFromGitHub {
    owner = "sionescu";
    repo = "bordeaux-threads";
    rev = "3d25cd01176f7c9215ebc792c78313cb99ff02f9";
    sha256 = "1hh2wn6gjfs22jqys2qsc33znn0mrrqj1lchsi9zfwq7p799dv8f";
    fetchSubmodules = true;
  };
  cffi = fetchFromGitHub {
    owner = "cffi";
    repo = "cffi";
    rev = "9c912e7b89eb09dd347d3ebae16e4dc5f53e5717";
    sha256 = "0fv1a5iv6q9sqcjza6wk2zv6sqsjn4daylk56fcp8czvclg78sxs";
  };
  cl-markup = fetchFromGitHub {
    owner = "arielnetworks";
    repo = "cl-markup";
    rev = "e0eb7debf4bdff98d1f49d0f811321a6a637b390";
    sha256 = "10l6k45971dl13fkdmva7zc6i453lmq9j4xax2ci6pjzlc6xjhp7";
  };
  cl-ppcre = fetchFromGitHub {
    owner = "edicl";
    repo = "cl-ppcre";
    rev = "b4056c5aecd9304e80abced0ef9c89cd66ecfb5e";
    sha256 = "13z548s88xrz2nscq91w3i33ymxacgq3zl62i8d31hqmwr4s45zb";
  };
  cl-svg = fetchFromGitHub {
    owner = "wmannis";
    repo = "cl-svg";
    rev = "1e988ebd2d6e2ee7be4744208828ef1b59e5dcdc";
    sha256 = "11rmzimy6j7ln7q5y1h2kw1225rsfb6fpn89qjcq7h5lc8fay0wz";
  };
  cleavir = fetchFromGitHub {
    owner = "s-expressionists";
    repo = "Cleavir";
    rev = "a73d313735447c63b4b11b6f8984f9b1e3e74ec9";
    sha256 = "VQ8sB5W7JYnVsvfx2j7d2LQcECst79MCIW9QSuwm8GA=";
    fetchSubmodules = true;
  };
  closer-mop = fetchFromGitHub {
    owner = "pcostanza";
    repo = "closer-mop";
    rev = "d4d1c7aa6aba9b4ac8b7bb78ff4902a52126633f";
    sha256 = "1amcv0f3vbsq0aqhai7ki5bi367giway1pbfxyc47r7q3hq5hw3c";
  };
  concrete-syntax-tree = fetchFromGitHub {
    owner = "s-expressionists";
    repo = "concrete-syntax-tree";
    rev = "4f01430c34f163356f3a2cfbf0a8a6963ff0e5ac";
    sha256 = "0XfLkihztWUhqu7DrFiuwcEx/x+EILEivPfsHb5aMZk=";
  };
  documentation-utils = fetchFromGitHub {
    owner = "Shinmera";
    repo = "documentation-utils";
    rev = "98630dd5f7e36ae057fa09da3523f42ccb5d1f55";
    sha256 = "uMUyzymyS19ODiUjQbE/iJV7HFeVjB45gbnWqfGEGCU=";
  };
  eclector = fetchFromGitHub {
    owner = "s-expressionists";
    repo = "Eclector";
    rev = "dddb4d8af3eae78017baae7fb9b99e73d2a56e6b";
    sha256 = "00raw4nfg9q73w1pj4r001g90g97n2rq6q3zijg5j6j7iq81df9s";
  };
  esrap = fetchFromGitHub {
    owner = "scymtym";
    repo = "esrap";
    rev = "7588b430ad7c52f91a119b4b1c9a549d584b7064";
    sha256 = "C0GiTyRna9BMIMy1/XdMZAkhjpLaoAEF1+ps97xQyMY=";
  };
  global-vars = fetchFromGitHub {
    owner = "lmj";
    repo = "global-vars";
    rev = "c749f32c9b606a1457daa47d59630708ac0c266e";
    sha256 = "bXxeNNnFsGbgP/any8rR3xBvHE9Rb4foVfrdQRHroxo=";
  };
  let-plus = fetchFromGitHub {
    owner = "sharplispers";
    repo = "let-plus";
    rev = "455e657e077235829b197f7ccafd596fcda69e30";
    sha256 = "SyZRx9cyuEN/h4t877TOWw35caQqMf2zSGZ9Qg22gAE=";
  };
  cl-netcdf = fetchFromGitHub {
    owner = "clasp-developers";
    repo = "cl-netcdf";
    rev = "593c6c47b784ec02e67580aa12a7775ed6260200";
    sha256 = "3VCTSsIbk0GovCM+rWPZj2QJdYq+UZksjfRd18UYY5s=";
  };
  lparallel = fetchFromGitHub {
    owner = "yitzchak";
    repo = "lparallel";
    rev = "9c98bf629328b27a5a3fbb7a637afd1db439c00f";
    sha256 = "sUM1WKXxZk7un64N66feXh21m7yzJsdcaWC3jIOd2W4=";
  };
  parser-common-rules = fetchFromGitHub {
    owner = "scymtym";
    repo = "parser.common-rules";
    rev = "b7652db5e3f98440dce2226d67a50e8febdf7433";
    sha256 = "ik+bteIjBN6MfMFiRBjn/nP7RBzv63QgoRKVi4F8Ho0=";
  };
  plump = fetchFromGitHub {
    owner = "Shinmera";
    repo = "plump";
    rev = "d8ddda7514e12f35510a32399f18e2b26ec69ddc";
    sha256 = "FjeZAWD81137lXWyN/RIr+L+anvwh/Glze497fcpHUY=";
  };
  split-sequence = fetchFromGitHub {
    owner = "sharplispers";
    repo = "split-sequence";
    rev = "89a10b4d697f03eb32ade3c373c4fd69800a841a";
    sha256 = "faF2EiQ+xXWHX9JlZ187xR2mWhdOYCpb4EZCPNoZ9uQ=";
  };
  static-vectors = fetchFromGitHub {
    owner = "sionescu";
    repo = "static-vectors";
    rev = "87a447a8eaef9cf4fd1c16d407a49f9adaf8adad";
    sha256 = "q4E+VPX/pOyuCdzJZ6CFEIiR58E6JIxJySROl/WcMyI=";
  };
  trivial-features = fetchFromGitHub {
    owner = "yitzchak";
    repo = "trivial-features";
    rev = "35c5eeb21a51671ffbfcb591f84498e782478a32";
    sha256 = "sy41Q/XFxH59JqGWM/azMkvKGwIcvB6OD6z+kP7cc2w=";
  };
  trivial-garbage = fetchFromGitHub {
    owner = "trivial-garbage";
    repo = "trivial-garbage";
    rev = "b3af9c0c25d4d4c271545f1420e5ea5d1c892427";
    sha256 = "CCLZHHW3/0Id0uHxrbjf/WM3yC8netkcQ8p9Qtssvc4=";
  };
  trivial-http = fetchFromGitHub {
    owner = "gwkkwg";
    repo = "trivial-http";
    rev = "ca45656587f36378305de1a4499c308acc7a03af";
    sha256 = "0VKWHJYn1XcXVNHduxKiABe7xFUxj8M4/u92Usvq54o=";
  };
  trivial-indent = fetchFromGitHub {
    owner = "Shinmera";
    repo = "trivial-indent";
    rev = "8d92e94756475d67fa1db2a9b5be77bc9c64d96c";
    sha256 = "G+YCIB3bKN4RotJUjT/6bnivSBalseFRhIlwsEm5EUk=";
  };
  trivial-with-current-source-form = fetchFromGitHub {
    owner = "scymtym";
    repo = "trivial-with-current-source-form";
    rev = "3898e09f8047ef89113df265574ae8de8afa31ac";
    sha256 = "1114iibrds8rvwn4zrqnmvm8mvbgdzbrka53dxs1q61ajv44x8i0";
  };
  usocket = fetchFromGitHub {
    owner = "usocket";
    repo = "usocket";
    rev = "7ad6582cc1ce9e7fa5931a10e73b7d2f2688fa81";
    sha256 = "0HiItuc6fV70Rpk/5VevI1I0mGnY1JJvhnyPpx6r0uo=";
  };
  asdf = fetchFromGitLab {
    domain = "gitlab.common-lisp.net";
    owner = "asdf";
    repo = "asdf";
    rev = "3.3.5";
    sha256 = "0gz7s22c6y0rz148w1sinxmqdk079k0k6rjrxpgaic14wqrqpk9q";
    fetchSubmodules = true;
  };
  mps = fetchFromGitHub {
    owner = "Ravenbrook";
    repo = "mps";
    rev = "b8a05a3846430bc36c8200f24d248c8293801503";
    sha256 = "1q2xqdw832jrp0w9yhgr8xihria01j4z132ac16lr9ssqznkprv6";
  };
  bdwgc = fetchFromGitHub {
    owner = "ivmai";
    repo = "bdwgc";
    rev = "v8.2.0";
    sha256 = "WB1sFfVL6lWL+DEypg3chCJS/w0J4tPGi5tL1o3W73U=";
  };
  libatomic_ops = fetchFromGitHub {
    owner = "ivmai";
    repo = "libatomic_ops";
    rev = "v7.6.12";
    sha256 = "zThdbX2/l5/ZZVYobJf9KAd+IjIDIrk+08SUhTQs2gE=";
  };
  cando = fetchFromGitHub {
    owner = "cando-developers";
    repo = "cando";
    rev = "a6934eddfce2ff1cb7131affce427ce652392f08";
    sha256 = "AUmBLrk7lofJNagvI3KhPebvV8GkrDbBXrsAa3a1Bwo=";
    fetchSubmodules = true;
  };
  seqan-clasp = fetchFromGitHub {
    owner = "clasp-developers";
    repo = "seqan-clasp";
    rev = "5caa2e1e6028525276a6b6ba770fa6e334563d58";
    sha256 = "xAvAd/kBr8n9SSw/trgWTqDWQLmpOp8+JX5L+JO2+Ls=";
  };
  seqan = fetchFromGitHub {
    owner = "seqan";
    repo = "seqan";
    rev = "f5f658343c366c9c3d44ba358ffc9317e78a09ed";
    sha256 = "AzZlONf7SNxCa9+SKQFC/rA6fx6rhWH96caZSmKnlsU=";
    fetchSubmodules = true;
  };
  stdenv = llvmPackages.stdenv;
in
stdenv.mkDerivation rec {
  pname = "clasp";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "clasp-developers";
    repo = "clasp";
    rev = version;
    fetchSubmodules = true;
    sha256 = "gvUqUb0dftW1miiBcAPJur0wOunox4y2SUYeeJpR9R4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ctags
    git
    sbcl
    ninja
    pkg-config
  ] ++ (with llvmPackages; [
    llvm
  ]);

  buildInputs = [
    gmp
    boost
    libelf
    fmt
  ] ++ (with llvmPackages; [
    libclang
  ]);

  postPatch = ''
    echo "creating directories found in ${src}/repos.sexp"
    mkdir -p $(grep -ri "directory" repos.sexp | sed -e 's/:directory //' -e 's/"//g')

    echo "copying dependencies to desired locations"
    cp -rfT "${ansi-test}" dependencies/ansi-test/
    cp -rfT "${cl-bench}" dependencies/cl-bench/
    cp -rfT "${cl-who}" dependencies/cl-who/
    cp -rfT "${quicklisp-client}" dependencies/quicklisp-client/
    cp -rfT "${shasht}" dependencies/shasht/
    cp -rfT "${trivial-do}" dependencies/trivial-do/
    cp -rfT "${trivial-gray-streams}" dependencies/trivial-gray-streams/
    cp -rfT "${acclimation}" src/lisp/kernel/contrib/Acclimation/
    cp -rfT "${alexandria}" src/lisp/kernel/contrib/alexandria/
    cp -rfT "${anaphora}" src/lisp/kernel/contrib/anaphora/
    cp -rfT "${architecture-builder-protocol}" src/lisp/kernel/contrib/architecture.builder-protocol/
    cp -rfT "${array-utils}" src/lisp/kernel/contrib/array-utils/
    cp -rfT "${babel}" src/lisp/kernel/contrib/babel/
    cp -rfT "${bordeaux-threads}" src/lisp/kernel/contrib/bordeaux-threads/
    cp -rfT "${cffi}" src/lisp/kernel/contrib/cffi/
    cp -rfT "${cl-markup}" src/lisp/kernel/contrib/cl-markup/
    cp -rfT "${cl-ppcre}" src/lisp/kernel/contrib/cl-ppcre/
    cp -rfT "${cl-svg}" src/lisp/kernel/contrib/cl-svg/
    cp -rfT "${cleavir}" src/lisp/kernel/contrib/Cleavir/
    cp -rfT "${closer-mop}" src/lisp/kernel/contrib/closer-mop/
    cp -rfT "${concrete-syntax-tree}" src/lisp/kernel/contrib/Concrete-Syntax-Tree/
    cp -rfT "${documentation-utils}" src/lisp/kernel/contrib/documentation-utils/
    cp -rfT "${eclector}" src/lisp/kernel/contrib/Eclector/
    cp -rfT "${esrap}" src/lisp/kernel/contrib/esrap/
    cp -rfT "${global-vars}" src/lisp/kernel/contrib/global-vars/
    cp -rfT "${let-plus}" src/lisp/kernel/contrib/let-plus/
    cp -rfT "${cl-netcdf}" src/lisp/kernel/contrib/cl-netcdf/
    cp -rfT "${lparallel}" src/lisp/kernel/contrib/lparallel/
    cp -rfT "${parser-common-rules}" src/lisp/kernel/contrib/parser.common-rules/
    cp -rfT "${plump}" src/lisp/kernel/contrib/plump/
    cp -rfT "${split-sequence}" src/lisp/kernel/contrib/split-sequence/
    cp -rfT "${static-vectors}" src/lisp/kernel/contrib/static-vectors/
    cp -rfT "${trivial-features}" src/lisp/kernel/contrib/trivial-features/
    cp -rfT "${trivial-garbage}" src/lisp/kernel/contrib/trivial-garbage/
    cp -rfT "${trivial-http}" src/lisp/kernel/contrib/trivial-http/
    cp -rfT "${trivial-indent}" src/lisp/kernel/contrib/trivial-indent/
    cp -rfT "${trivial-with-current-source-form}" src/lisp/kernel/contrib/trivial-with-current-source-form/
    cp -rfT "${usocket}" src/lisp/kernel/contrib/usocket/
    cp -rfT "${asdf}" src/lisp/modules/asdf/
    cp -rfT "${mps}" src/mps/
    cp -rfT "${bdwgc}" src/bdwgc/
    cp -rfT "${libatomic_ops}" src/libatomic_ops/
    cp -rfT "${cando}" extensions/cando/
    cp -rfT "${seqan-clasp}" extensions/seqan-clasp/
    cp -rfT "${seqan}" extensions/seqan-clasp/seqan/
  '';

  configurePhase = ''
    runHook preConfigure

    echo "executing workaround for '/homeless-shelter'"
    export XDG_CACHE_HOME=$PWD/.cache
    mkdir -p "$XDG_CACHE_HOME"

    echo "executing koga with ${sbcl}/bin/sbcl"
    ${sbcl}/bin/sbcl --script koga \
      --skip-sync \
      --pkg-config=${pkg-config}/bin/pkg-config \
      --cc=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc \
      --cxx=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++ \
      --ctags=${ctags}/bin/ctags \
      --jobs=$NIX_BUILD_CORES \
      --prefix=$out/ \
      --bin-path=$out/bin/ \
      --lib-path=$out/lib/clasp/ \
      --share-path=$out/share/clasp/ \
      --reproducible-build \
      --extensions=seqan-clasp

    runHook postConfigure
  '';

  preBuild = ''
    cd build
  '';

  # Long build, high RAM requirement
  enableParallelBuilding = true;
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "A Common Lisp implementation based on LLVM with C++ integration";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ raskin phossil OPNA2608 ];
    # https://github.com/clasp-developers/clasp/blob/95e8cedcd5c5f8f1c064e7cab4e640f00a175d90/src/core/corePackage.cc#L1293
    # "Currently only x86_64 and i386 is supported"
    platforms = platforms.x86;
    # Untested
    broken = stdenv.isDarwin;
    homepage = "https://clasp-developers.github.io/";
  };
}
