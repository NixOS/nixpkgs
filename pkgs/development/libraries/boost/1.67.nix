{ lib, stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.67.0";

  patches = [
    (fetchpatch {
      url = "https://github.com/boostorg/lockfree/commit/12726cda009a855073b9bedbdce57b6ce7763da2.patch";
      sha256 = "0x65nkwzv8fdacj8sw5njl3v63jj19dirrpklbwy6qpsncw7fc7h";
      stripLen = 1;
    })
  ] ++ lib.optionals stdenv.cc.isClang [
    # Fixes https://github.com/boostorg/atomic/issues/15
    (fetchpatch {
      url = "https://github.com/boostorg/atomic/commit/6e14ca24dab50ad4c1fa8c27c7dd6f1cb791b534.patch";
      sha256 = "102g35ygvv8cxagp9651284xk4vybk93q2fm577y4mdxf5k46b7a";
      stripLen = 1;
    })

    # Needed for the next patch
    (fetchpatch {
      url = "https://github.com/boostorg/asio/commit/38cb19719748ad56b14d73ca1fff5828f36e5894.patch";
      sha256 = "0cj9cxz9rfbsx8p8f5alxx00dq3r7g0vh23j68bbxbs9gq1arq2n";
      stripLen = 1;
    })
    # Fixes https://github.com/boostorg/asio/pull/91
    (fetchpatch {
      url = "https://github.com/boostorg/asio/commit/43874d5497414c67655d901e48c939ef01337edb.patch";
      sha256 = "1c2ds164s2ygvpb4785p4ncv8ywbpm08cphirb99xp4mqvb693is";
      stripLen = 1;
    })
  ];

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2";
    # SHA256 from http://www.boost.org/users/history/version_1_66_0.html
    sha256 = "2684c972994ee57fc5632e03bf044746f6eb45d4920c343937a465fd67a5adba";
  };
})
