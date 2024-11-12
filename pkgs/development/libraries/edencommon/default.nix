{ stdenv
, lib
, fetchFromGitHub
, boost
, cmake
, fmt_8
, folly
, glog
, gtest
}:

stdenv.mkDerivation rec {
  pname = "edencommon";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "edencommon";
    rev = "v${version}";
    sha256 = "sha256-1z4QicS98juv4bUEbHBkCjVJHEhnoJyLYp4zMHmDbMg=";
  };

  patches = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Test discovery timeout is bizarrely flaky on `x86_64-darwin`
    ./increase-test-discovery-timeout.patch
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.14" # For aligned allocation
  ];

  buildInputs = [
    glog
    folly
    fmt_8
    boost
    gtest
  ];

  meta = with lib; {
    description = "Shared library for Meta's source control filesystem tools (EdenFS and Watchman)";
    homepage = "https://github.com/facebookexperimental/edencommon";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kylesferrazza ];
  };
}
