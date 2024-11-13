{
  stdenv,
  fetchFromGitHub,
  cmake,
  libevent,
  double-conversion,
  glog,
  lib,
  zstd,
  gflags,
  libiberty,
  openssl,
  folly,
  libsodium,
  gtest,
  zlib,
  apple-sdk_11,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fizz";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fizz";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-IHWotiVUjGOvebXy4rwsh8U8UMxTrF1VaqXzZMjojiM=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeDir = "../fizz";

  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  NIX_LDFLAGS = "-lz";

  buildInputs =
    [
      double-conversion
      folly
      glog
      gflags
      libevent
      libiberty
      libsodium
      openssl
      zlib
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  doCheck = true;
  checkInputs = [
    gtest
  ];
  preCheck =
    let
      disabledTests = [
        # these don't work with openssl 3.x probably due to
        # https://github.com/openssl/openssl/issues/13283
        "DefaultCertificateVerifierTest.TestVerifySuccess"
        "DefaultCertificateVerifierTest.TestVerifyWithIntermediates"

        # timing-related & flaky
        "SlidingBloomReplayCacheTest.TestTimeBucketing"
      ];
    in
    ''
      export GTEST_FILTER="-${lib.concatStringsSep ":" disabledTests}"
    '';

  meta = with lib; {
    description = "C++14 implementation of the TLS-1.3 standard";
    homepage = "https://github.com/facebookincubator/fizz";
    changelog = "https://github.com/facebookincubator/fizz/releases/tag/v${finalAttrs.version}";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      pierreis
      kylesferrazza
    ];
  };
})
