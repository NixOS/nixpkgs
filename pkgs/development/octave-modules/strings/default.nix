{
  buildOctavePackage,
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  pcre2,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "strings";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-strings";
    tag = "release-${version}";
    sha256 = "sha256-VkF6GF//NbiEcWqSo48QeKqoJR8zvk1KWGzVJwhzHRU=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    pcre2
  ];

  # autoreconfHook provides an autoreconfPhase that is run as a
  # preconfigurePhase, which means it runs AFTER the source is un-tarred, and
  # before buildOctavePackage's buildPhase re-tars it up into a format for later
  # consumption by Octave's "pkg build" command.
  preAutoreconf = ''
    pushd src
    rm -rf config.*
  '';
  postAutoreconf = ''
    popd
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(.*)"
    ];
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/strings/";
    # No license file, but has copyright header in files.
    license = [
      # The .m files are GPL3+
      lib.licenses.gpl3Plus
      # The C++ files are BSD2
      lib.licenses.bsd2
    ];
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Additional functions for manipulation and analysis of strings";
    # Some pcre symbols claimed to be missing
    broken = stdenv.hostPlatform.isDarwin;
  };
}
