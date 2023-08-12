{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, python3
, zlib
, libssh2
, openssl
, pcre
, http-parser
, libiconv
, Security
, staticBuild ? stdenv.hostPlatform.isStatic
# for passthru.tests
, libgit2-glib
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "libgit2";
  version = "1.7.0";
  # also check the following packages for updates: python3Packages.pygit2 and libgit2-glib

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    hash = "sha256-3ZVBGd2T5DQKsDEc5a7pS0yz01+rDCszU9ZK0zxvfyQ=";
  };

  patches = [
    (fetchpatch {
      name = "darwin-errSSLNetworkTimeout.patch";
      url = "https://github.com/libgit2/libgit2/commit/3e15292d8863da316a57be23fede04f443460686.patch";
      hash = "sha256-N314YK7osO9L3hCXb+FcMoDM8iBW9Bt8D5O2Szdz7YA=";
    })
    (fetchpatch {
      name = "missing-git_oidarray.patch";
      url = "https://github.com/libgit2/libgit2/commit/085a169c1d73e02888708652d7772b3bc1f1b28b.diff";
      hash = "sha256-l6q1TLuOloyk0Jqvo5Npv4grU/oxlg+RFLa43qENaLI=";
    })
  ];

  cmakeFlags = [
    "-DUSE_HTTP_PARSER=system"
    "-DUSE_SSH=ON"
    "-DBUILD_SHARED_LIBS=${if staticBuild then "OFF" else "ON"}"
  ];

  nativeBuildInputs = [ cmake python3 pkg-config ];

  buildInputs = [ zlib libssh2 openssl pcre http-parser ]
    ++ lib.optional stdenv.isDarwin Security;

  propagatedBuildInputs = lib.optional (!stdenv.isLinux) libiconv;

  doCheck = false; # hangs. or very expensive?

  passthru.tests = {
    inherit libgit2-glib;
    inherit (python3Packages) pygit2;
  };

  meta = with lib; {
    description = "Linkable library implementation of Git that you can use in your application";
    homepage = "https://libgit2.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
