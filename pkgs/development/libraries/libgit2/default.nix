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
, pcre2
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
  version = "1.9.0";
  # also check the following packages for updates: python3Packages.pygit2 and libgit2-glib

  outputs = ["lib" "dev" "out"];

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v32yGMo5oFEl6HUdg8czCsCLDL+sy9PPT0AEWmKxUhk=";
  };

  patches = [
    (fetchpatch {
      name = "libgit2-darwin-case-sensitive-build.patch";
      url = "https://github.com/libgit2/libgit2/commit/1b348a31349e847b1d8548281aa92f26b9783f2f.patch";
      hash = "sha256-CBaUuEr3nPdUuOdyJtmPgyqR0MNnVyOFYbYXF3ncupU=";
    })
  ];

  cmakeFlags = [
    "-DREGEX_BACKEND=pcre2"
    "-DUSE_HTTP_PARSER=llhttp"
    "-DUSE_SSH=ON"
    (lib.cmakeBool "USE_GSSAPI" withGssapi)
    "-DBUILD_SHARED_LIBS=${if staticBuild then "OFF" else "ON"}"
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [
    "-DDLLTOOL=${stdenv.cc.bintools.targetPrefix}dlltool"
    # For ws2_32, referred to by a `*.pc` file
    "-DCMAKE_LIBRARY_PATH=${stdenv.cc.libc}/lib"
  ] ++ lib.optionals stdenv.hostPlatform.isOpenBSD [
    # openbsd headers fail with default c90
    "-DCMAKE_C_STANDARD=99"
  ];

  nativeBuildInputs = [ cmake python3 pkg-config ];

  buildInputs = [ zlib libssh2 openssl pcre2 llhttp ]
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
