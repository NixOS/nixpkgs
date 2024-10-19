{ lib
, stdenv
, fetchFromGitHub
, cmake
, nix
}:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.9.27";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VbF+R2LB5M2luOoQ/HsAOqk/ujHSW4QJC0OTzNnu9PM=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ lib.optionals stdenv.hostPlatform.isRiscV [
    "-DCMAKE_C_FLAGS=-fasynchronous-unwind-tables"
  ];

  # aws-c-common misuses cmake modules, so we need
  # to manually add a MODULE_PATH to its consumers
  setupHook = ./setup-hook.sh;

  # Prevent the execution of tests known to be flaky.
  preCheck = let
    ignoreTests = [
      "promise_test_multiple_waiters"
    ] ++ lib.optionals stdenv.hostPlatform.isMusl [
      "sba_metrics" # https://github.com/awslabs/aws-c-common/issues/839
    ];
  in ''
    cat <<EOW >CTestCustom.cmake
    SET(CTEST_CUSTOM_TESTS_IGNORE ${toString ignoreTests})
    EOW
  '';

  doCheck = true;

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "AWS SDK for C common core";
    homepage = "https://github.com/awslabs/aws-c-common";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej r-burns ];
  };
}
