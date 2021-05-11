{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, zlib
, expat
, cmake
, which
, libxml2
, python3
, gettext
, doxygen
, graphviz
, libxslt
}:

stdenv.mkDerivation rec {
  pname = "exiv2";
  version = "0.27.3";

  outputs = [ "out" "dev" "doc" "man" ];

  src = fetchFromGitHub {
    owner = "exiv2";
    repo  = "exiv2";
    rev = "v${version}";
    sha256 = "0d294yhcdw8ziybyd4rp5hzwknzik2sm0cz60ff7fljacv75bjpy";
  };

  patches = [
    # Fix aarch64 build https://github.com/Exiv2/exiv2/pull/1271
    (fetchpatch {
      name = "cmake-fix-aarch64.patch";
      url = "https://github.com/Exiv2/exiv2/commit/bbe0b70840cf28b7dd8c0b7e9bb1b741aeda2efd.patch";
      sha256 = "13zw1mn0ag0jrz73hqjhdsh1img7jvj5yddip2k2sb5phy04rzfx";
    })

    # Use correct paths with multiple outputs
    # https://github.com/Exiv2/exiv2/pull/1275
    (fetchpatch {
      url = "https://github.com/Exiv2/exiv2/commit/48f2c9dbbacc0ef84c8ebf4cb1a603327f0b8750.patch";
      sha256 = "vjB3+Ld4c/2LT7nq6uatYwfHTh+HeU5QFPFXuNLpIPA=";
    })
    # https://github.com/Exiv2/exiv2/pull/1294
    (fetchpatch {
      url = "https://github.com/Exiv2/exiv2/commit/306c8a6fd4ddd70e76043ab255734720829a57e8.patch";
      sha256 = "0D/omxYxBPGUu3uSErlf48dc6Ukwc2cEN9/J3e7a9eU=";
    })
    # https://github.com/Exiv2/exiv2/pull/1523
    (fetchpatch {
      name = "CVE-2021-3482_1.patch";
      url = "https://github.com/Exiv2/exiv2/commit/22ea582c6b74ada30bec3a6b15de3c3e52f2b4da.patch";
      sha256 = "0z9hcywjzb2q3yh3kkvjcg70rz3l7vgqjhk1h9wn291ys0jc2yxm";
    })
    (fetchpatch {
      name = "CVE-2021-3482_2.patch";
      url = "https://github.com/Exiv2/exiv2/commit/cac151ec052d44da3dc779e9e4028e581acb128a.patch";
      sha256 = "1jyh0almvbg47c7i46hk9vg05v1r6mzc89xc7y6d8zcrvhyra0wk";
    })

    # https://github.com/Exiv2/exiv2/pull/1534
    (fetchpatch {
      name = "CVE-2021-29457.patch";
      url = "https://github.com/Exiv2/exiv2/commit/13e5a3e02339b746abcaee6408893ca2fd8e289d.patch";
      sha256 = "19nkdpn7jdm1rp8na68djzrl6rxdl1n5n4974ypazpmqr04x0j79";
    })
    # https://github.com/Exiv2/exiv2/pull/1539
    (fetchpatch {
      name = "CVE-2021-29458_1.patch";
      url = "https://github.com/Exiv2/exiv2/commit/0a91b56616404f7b29ca28deb01ce18b767d1871.patch";
      sha256 = "0ryjp2pzlj5h79q67y7az91yhmdqhdpgdg3mlc2qdamsqdp29m2b";
    })
    (fetchpatch {
      name = "CVE-2021-29458_2.patch";
      url = "https://github.com/Exiv2/exiv2/commit/c92ac88cb0ebe72a5a17654fe6cecf411ab1e572.patch";
      sha256 = "1g7xm7mkr01lvd4d0hikswxbdmb5q2ihw4ddxhc0shsg3lkv3zqp";
    })
    (fetchpatch {
      name = "CVE-2021-29458_3.patch";
      url = "https://github.com/Exiv2/exiv2/commit/9b7a19f957af53304655ed1efe32253a1b11a8d0.patch";
      sha256 = "0a8xqmh97q7gj727yz4gbrzh5jsmlg2a45fjfl3wychpwbn7dqlc";
    })
    (fetchpatch {
      name = "CVE-2021-29458_4.patch";
      url = "https://github.com/Exiv2/exiv2/commit/fadb68718eb1bff3bd3222bd26ff3328f5306730.patch";
      sha256 = "1hx6jf17if4afrz9halky7rlpvmgvysd46bby3zk6hipv8s8bk6h";
    })
    (fetchpatch {
      name = "CVE-2021-29458_5.patch";
      url = "https://github.com/Exiv2/exiv2/commit/06d2db6e5fd2fcca9c060e95fc97f8a5b5d4c22d.patch";
      sha256 = "1mh4ww2rj3a2kd0i2510zgv2n72wd0p3j1xd735ndp85fzvw4n3z";
    })
    # https://github.com/Exiv2/exiv2/pull/1581
    (fetchpatch {
      name = "CVE-2021-29470_1.patch";
      url = "https://github.com/Exiv2/exiv2/commit/6527e4f5979ced22d509e27d87d51287046f2008.patch";
      sha256 = "0djh19xvn7p9bn06flznjw3xsjpmn10cdxwqq9xgh5k4f6ic4fz1";
    })
    ./CVE-2021-29470_2.patch  # rebased on top of v0.27.3
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    graphviz
    libxslt
  ];

  propagatedBuildInputs = [
    expat
    zlib
  ];

  checkInputs = [
    libxml2.bin
    python3
    which
  ];

  cmakeFlags = [
    "-DEXIV2_ENABLE_NLS=ON"
    "-DEXIV2_BUILD_DOC=ON"
  ];

  buildFlags = [
    "all"
    "doc"
  ];

  doCheck = true;

  # Test setup found by inspecting ${src}/.travis/run.sh; problems without cmake.
  checkTarget = "tests";

  preCheck = ''
    patchShebangs ../test/
    mkdir ../test/tmp

    ${lib.optionalString (stdenv.isAarch64 || stdenv.isAarch32) ''
      # Fix tests on arm
      # https://github.com/Exiv2/exiv2/issues/933
      rm -f ../tests/bugfixes/github/test_CVE_2018_12265.py
    ''}

    ${lib.optionalString stdenv.isDarwin ''
      export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD/lib
      # Removing tests depending on charset conversion
      substituteInPlace ../test/Makefile --replace "conversions.sh" ""
      rm -f ../tests/bugfixes/redmine/test_issue_460.py
      rm -f ../tests/bugfixes/redmine/test_issue_662.py
      rm -f ../tests/bugfixes/github/test_issue_1046.py
     ''}
  '';

  # With CMake we have to enable samples or there won't be
  # a tests target. This removes them.
  postInstall = ''
    ( cd "$out/bin"
      mv exiv2 .exiv2
      rm *
      mv .exiv2 exiv2
    )
  '';

  meta = with lib; {
    homepage = "https://www.exiv2.org/";
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
