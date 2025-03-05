{ lib
, clangStdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libimobiledevice
, libusb1
, avahi
, clang
, git
}: let

  libgeneral = clangStdenv.mkDerivation rec {
    pname = "libgeneral";
    version = "74";
    src = fetchFromGitHub {
      owner = "tihmstar";
      repo = pname;
      rev = "refs/tags/${version}";
      hash = "sha256-6aowcIYssc1xqH6kTi/cpH2F7rgc8+lGC8HgZWYH2w0=";
      # Leave DotGit so that autoconfigure can read version from git tags
      leaveDotGit = true;
    };
    nativeBuildInputs = [
      autoreconfHook
      git
      pkg-config
    ];
    meta = with lib; {
      description = "Helper library used by usbmuxd2";
      homepage = "https://github.com/tihmstar/libgeneral";
      license = licenses.lgpl21;
      platforms = platforms.all;
    };
  };

in
clangStdenv.mkDerivation rec {
  pname = "usbmuxd2";
  version = "unstable-2023-12-12";

  src = fetchFromGitHub {
    owner = "tihmstar";
    repo = pname;
    rev = "2ce399ddbacb110bd5a83a6b8232d42c9a9b6e84";
    hash = "sha256-UVLLE73XuWTgGlpTMxUDykFmiBDqz6NCRO2rpRAYfow=";
    # Leave DotGit so that autoconfigure can read version from git tags
    leaveDotGit = true;
  };

  postPatch = ''
    # Checking for libgeneral version still fails
    sed -i 's/libgeneral >= $LIBGENERAL_MINVERS_STR/libgeneral/' configure.ac
  '';

  nativeBuildInputs = [
    autoreconfHook
    clang
    git
    pkg-config
  ];

  propagatedBuildInputs = [
    avahi
    libgeneral
    libimobiledevice
    libusb1
  ];

  configureFlags = [
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  makeFlags = [
    "sbindir=${placeholder "out"}/bin"
  ];

  meta = with lib; {
    homepage = "https://github.com/tihmstar/usbmuxd2";
    description = "Socket daemon to multiplex connections from and to iOS devices";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
    mainProgram = "usbmuxd";
  };
}
