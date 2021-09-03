{ lib
, stdenv
, fetchFromGitHub
, cmake
, coreutils
}:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bnKIL51AW+0T87BxEazXDZElYqiwOUHQVEDKOCUzsbM=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # for tests
  ];

  # Prevent the execution of tests known to be flaky.
  preCheck = ''
    cat <<EOW >CTestCustom.cmake
    SET(CTEST_CUSTOM_TESTS_IGNORE promise_test_multiple_waiters)
    EOW
  '';

  doCheck = true;

  meta = with lib; {
    description = "AWS SDK for C common core";
    homepage = "https://github.com/awslabs/aws-c-common";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco r-burns ];
  };
}
