{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake, perl, static ? false }:

stdenv.mkDerivation rec {
  pname = "glog";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    rev = "v${version}";
    sha256 = "1xd3maiipfbxmhc9rrblc5x52nxvkwxp14npg31y5njqvkvzax9b";
  };

  patches = lib.optionals stdenv.hostPlatform.isMusl [
    # TODO: Remove at next release that includes this commit.
    (fetchpatch {
      name = "glog-Fix-symbolize_unittest-for-musl-builds.patch";
      url = "https://github.com/google/glog/commit/834dd780bf1fe0704b8ed0350ca355a55f711a9f.patch";
      sha256 = "0k4lanxg85anyvjsj3mh93bcgds8gizpiamcy2zvs3yyfjl40awn";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}" ];

  checkInputs = [ perl ];
  doCheck = false; # fails with "Mangled symbols (28 out of 380) found in demangle.dm"

  meta = with stdenv.lib; {
    homepage = "https://github.com/google/glog";
    license = licenses.bsd3;
    description = "Library for application-level logging";
    platforms = platforms.unix;
  };
}
