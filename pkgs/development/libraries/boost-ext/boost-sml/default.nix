{ stdenv
, lib
, cmake
, fetchFromGitHub
, boost
}:

stdenv.mkDerivation rec {
  pname = "boost-sml";
  # This is first commit since 1.1.6 that passes all tests (test_policies_logging is commented out)
  version = "1.1.6";
  working_tests = "24d762d1901f4f6afaa5c5e0d1b7b77537964694";

  src = fetchFromGitHub {
    owner = "boost-ext";
    repo = "sml";
    rev = "${working_tests}";
    hash = "sha256-ZhIfyYdzrzPTAYevOz5I6tAcUiLRMV8HENKX9jychEY=";
  };

  buildInputs = [ boost ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DSML_BUILD_BENCHMARKS=OFF"
    "-DSML_BUILD_EXAMPLES=OFF"
    "-DSML_BUILD_TESTS=ON"
    "-DSML_USE_EXCEPTIONS=ON"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Header only state machine library with no dependencies";
    homepage = "https://github.com/boost-ext/sml";
    license = licenses.boost;
    maintainers = with maintainers; [ prtzl ];
    platforms = platforms.all;
  };
}

