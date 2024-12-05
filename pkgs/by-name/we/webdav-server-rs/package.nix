{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libtirpc
, pam
, rpcsvc-proto
, enablePAM ? stdenv.hostPlatform.isLinux
}:

rustPlatform.buildRustPackage rec {
  pname = "webdav-server-rs";
  # The v0.4.0 tag cannot build.  So we use the 547602e commit.
  version = "unstable-2021-08-16";

  src = fetchFromGitHub {
    owner = "miquels";
    repo = pname;
    rev = "547602e78783935b4ddd038fb795366c9c476bcc";
    sha256 = "sha256-nTygUEjAUXD0mRTmjt8/UPVfZA4rP6oop1s/fI5mYeg=";
  };

  cargoHash = "sha256-TDDfGQig4i/DpsilTPqMQ1oT0mXK5DKlZmwsPPLrzFc=";

  buildInputs = [ libtirpc ] ++ lib.optional enablePAM pam;
  nativeBuildInputs = [ rpcsvc-proto ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "quota" ] ++ lib.optional enablePAM "pam";

  postPatch = ''
    substituteInPlace fs_quota/build.rs \
       --replace '/usr/include/tirpc' '${libtirpc.dev}/include/tirpc'
  '';

  meta = with lib; {
    description = "Implementation of WebDAV server in Rust";
    longDescription = ''
      webdav-server-rs is an implementation of WebDAV with full support for
      RFC4918.  It also supports local unix accounts, PAM authentication, and
      quota.
    '';
    homepage = "https://github.com/miquels/webdav-server-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ pmy ];
    mainProgram = "webdav-server";
  };
}
