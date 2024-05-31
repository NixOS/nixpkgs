{ lib
, stdenv
, fetchFromGitHub
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
, gitstatus
}:

stdenv.mkDerivation rec {
  pname = "libgit2";
  version = "1.7.2";
  # also check the following packages for updates: python3Packages.pygit2 and libgit2-glib

  outputs = ["lib" "dev" "out"];

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    hash = "sha256-fVPY/byE2/rxmv/bUykcAbmUFMlF3UZogVuTzjOXJUU=";
  };

  cmakeFlags = [
    "-DUSE_HTTP_PARSER=system"
    "-DUSE_SSH=ON"
    "-DBUILD_SHARED_LIBS=${if staticBuild then "OFF" else "ON"}"
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [
    "-DDLLTOOL=${stdenv.cc.bintools.targetPrefix}dlltool"
    # For ws2_32, refered to by a `*.pc` file
    "-DCMAKE_LIBRARY_PATH=${stdenv.cc.libc}/lib"
  ];

  nativeBuildInputs = [ cmake python3 pkg-config ];

  buildInputs = [ zlib libssh2 openssl pcre http-parser ]
    ++ lib.optional stdenv.isDarwin Security;

  propagatedBuildInputs = lib.optional (!stdenv.isLinux) libiconv;

  doCheck = true;
  checkPhase = ''
    testArgs=(-v -xonline)

    # slow
    testArgs+=(-xclone::nonetwork::bad_urls)

    # failed to set permissions on ...: Operation not permitted
    testArgs+=(-xrepo::init::extended_1)
    testArgs+=(-xrepo::template::extended_with_template_and_shared_mode)

    (
      set -x
      ./libgit2_tests ''${testArgs[@]}
    )
  '';

  passthru.tests = {
    inherit libgit2-glib;
    inherit (python3Packages) pygit2;
    inherit gitstatus;
  };

  meta = with lib; {
    description = "Linkable library implementation of Git that you can use in your application";
    mainProgram = "git2";
    homepage = "https://libgit2.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
