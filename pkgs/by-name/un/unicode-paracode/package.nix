{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  installShellFiles,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "unicode";
  version = "3.2-1"; # From `debian/changelog` in the repo

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "unicode";
    # TODO: Change back to "v${version}" after https://github.com/garabik/unicode/issues/27 is fixed.
    rev = "fa4fa6118d68c693ee14b97df6bf12d2fdbb37df";
    sha256 = "sha256-wgPJKzblwntRRD2062TPEth28KDycVqWheMTz0v5BVE=";
  };

  ucdtxt = fetchurl {
    url = "https://www.unicode.org/Public/15.0.0/ucd/UnicodeData.txt";
    sha256 = "sha256-gG6a7WUDcZfx7IXhK+bozYcPxWCLTeD//ZkPaJ83anM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postFixup = ''
    substituteInPlace "$out/bin/.unicode-wrapped" \
      --replace "/usr/share/unicode/UnicodeData.txt" "$ucdtxt"
  '';

  postInstall = ''
    installManPage paracode.1 unicode.1
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Display unicode character properties";
    homepage = "https://github.com/garabik/unicode";
    license = licenses.gpl3;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.all;
  };
}
