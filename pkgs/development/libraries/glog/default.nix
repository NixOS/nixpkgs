{ stdenv, lib, fetchFromGitHub, cmake, gflags, gtest, perl }:

stdenv.mkDerivation rec {
  pname = "glog";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    rev = "v${version}";
    sha256 = "sha256-xqRp9vaauBkKz2CXbh/Z4TWqhaUtqfbsSlbYZR/kW9s=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gtest ];

  propagatedBuildInputs = [ gflags ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  # TODO: Re-enable Darwin tests once we're on a release that has https://github.com/google/glog/issues/709#issuecomment-960381653 fixed
  doCheck = !stdenv.isDarwin;
  # There are some non-thread safe tests that can fail
  enableParallelChecking = false;
  checkInputs = [ perl ];

  GTEST_FILTER =
    let
      filteredTests = lib.optionals stdenv.hostPlatform.isMusl [
        "Symbolize.SymbolizeStackConsumption"
        "Symbolize.SymbolizeWithDemanglingStackConsumption"
      ] ++ lib.optionals stdenv.hostPlatform.isStatic [
        "LogBacktraceAt.DoesBacktraceAtRightLineWhenEnabled"
      ];
    in
    lib.optionalString doCheck "-${builtins.concatStringsSep ":" filteredTests}";

  meta = with lib; {
    homepage = "https://github.com/google/glog";
    license = licenses.bsd3;
    description = "Library for application-level logging";
    platforms = platforms.unix;
    maintainers = with maintainers; [ nh2 r-burns ];
  };
}
