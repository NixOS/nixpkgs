{
  stdenv,
  lib,
  fetchFromGitHub,
  boost,
  cmake,
  fmt_8,
  folly,
  glog,
  gtest,
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

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.isDarwin [
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
    description = "A shared library for Meta's source control filesystem tools (EdenFS and Watchman)";
    homepage = "https://github.com/facebookexperimental/edencommon";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kylesferrazza ];
  };
}
