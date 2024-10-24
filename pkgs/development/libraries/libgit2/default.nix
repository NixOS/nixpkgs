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
, libiconv
, Security
, staticBuild ? stdenv.hostPlatform.isStatic
# for passthru.tests
, libgit2-glib
, python3Packages
, gitstatus
, llhttp
, withGssapi ? false
, krb5
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgit2";
  version = "1.8.1";
  # also check the following packages for updates: python3Packages.pygit2 and libgit2-glib

  outputs = ["lib" "dev" "out"];

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J2rCxTecyLbbDdsyBWn9w7r3pbKRMkI9E7RvRgAqBdY=";
  };

  cmakeFlags = [
    "-DUSE_HTTP_PARSER=system"
    "-DUSE_SSH=ON"
    (lib.cmakeBool "USE_GSSAPI" withGssapi)
    "-DBUILD_SHARED_LIBS=${if staticBuild then "OFF" else "ON"}"
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [
    "-DDLLTOOL=${stdenv.cc.bintools.targetPrefix}dlltool"
    # For ws2_32, refered to by a `*.pc` file
    "-DCMAKE_LIBRARY_PATH=${stdenv.cc.libc}/lib"
  ];

  nativeBuildInputs = [ cmake python3 pkg-config ];

  buildInputs = [ zlib libssh2 openssl pcre llhttp ]
    ++ lib.optional withGssapi krb5
    ++ lib.optional stdenv.hostPlatform.isDarwin Security;

  propagatedBuildInputs = lib.optional (!stdenv.hostPlatform.isLinux) libiconv;

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

  passthru.tests = lib.mapAttrs (_: v: v.override { libgit2 = finalAttrs.finalPackage; }) {
    inherit libgit2-glib;
    inherit (python3Packages) pygit2;
    inherit gitstatus;
  };

  meta = with lib; {
    description = "Linkable library implementation of Git that you can use in your application";
    mainProgram = "git2";
    homepage = "https://libgit2.org/";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
})
