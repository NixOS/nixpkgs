{
  fetchFromGitHub,
  fetchpatch2,
  lib,
  stdenv,
  flex,
  bison,
  autoreconfHook,
  pkg-config,
  libtirpc,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "unfs3";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "unfs3";
    repo = "unfs3";
    rev = "refs/tags/unfs3-${version}";
    hash = "sha256-5iAriIutBhwyZVS7AG2fnkrHOI7pNAKfYv062Cy0WXw=";
  };

  patches = [
    # Fix implicit declaration warning with GCC 14
    (fetchpatch2 {
      url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/152dc14a65a89f253294cc5b4c96cf0d6658711a/main/unfs3/implicit.patch";
      hash = "sha256-zrF87fJhc8mDgIs0vsMoqIHYQPtKWn2XMBSePvHOByA=";
    })
  ];

  nativeBuildInputs = [
    flex
    bison
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libtirpc ];

  configureFlags = [ "--disable-shared" ];

  doCheck = false; # no test suite

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/unfsd";
  versionCheckProgramArg = "-h";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "${pname}-(.*)"
      ];
    };
  };

  meta = {
    description = "User-space NFSv3 file system server";

    longDescription = ''
      UNFS3 is a user-space implementation of the NFSv3 server
      specification.  It provides a daemon for the MOUNT and NFS
      protocols, which are used by NFS clients for accessing files on the
      server.
    '';

    # The old http://unfs3.sourceforge.net/ has a <meta>
    # http-equiv="refresh" pointing here, so we can assume that
    # whoever controls the old URL approves of the "unfs3" github
    # account.
    homepage = "https://unfs3.github.io/";
    changelog = "https://raw.githubusercontent.com/unfs3/unfs3/unfs3-${version}/NEWS";
    mainProgram = "unfsd";

    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
