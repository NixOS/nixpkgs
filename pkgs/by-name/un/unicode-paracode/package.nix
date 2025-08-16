{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  installShellFiles,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  # We want `pname = "unicode"` so that `nix run nixpkgs#unicode-paracode -- z` runs the `unicode` binary.
  pname = "unicode";
  version = "3.2"; # From `debian/changelog` in the repo
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "unicode";
    # TODO: Change back to "v${version}" after https://github.com/garabik/unicode/issues/27 is fixed.
    rev = "fa4fa6118d68c693ee14b97df6bf12d2fdbb37df";
    sha256 = "sha256-wgPJKzblwntRRD2062TPEth28KDycVqWheMTz0v5BVE=";
  };

  ucdtxt = fetchurl {
    url = "https://www.unicode.org/Public/16.0.0/ucd/UnicodeData.txt";
    sha256 = "sha256-/1jlgjvQlRZlZKAG5H0RETCBPc+L8jTvefpRqHDttI8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = with python3Packages; [ setuptools ];

  postFixup = ''
    mkdir -p "$out/share/unicode"
    ln -s "$ucdtxt" "$out/share/unicode/UnicodeData.txt"
    # We want to keep /usr/share/unicode in the list for the Unihan files
    substituteInPlace "$out/bin/.unicode-wrapped" \
      --replace-fail "'/usr/share/unicode', " "'$out/share/unicode', '/usr/share/unicode', "
  '';

  postInstall = ''
    installManPage paracode.1 unicode.1
  '';

  checkPhase = ''
    runHook preCheck

    echo Testing: $out/bin/unicode --brief z
    diff -u <(echo z U+007A LATIN SMALL LETTER Z) <($out/bin/unicode --brief z 2>&1) && echo Success

    runHook postCheck
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Display unicode character properties";
    homepage = "https://github.com/garabik/unicode";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.woffs ];
    platforms = lib.platforms.all;
  };
}
