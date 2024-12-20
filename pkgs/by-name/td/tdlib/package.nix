{
  fetchFromGitHub,
  gperf,
  openssl,
  readline,
  zlib,
  cmake,
  lib,
  stdenv,
  writeShellApplication,
  common-updater-scripts,
  jq,
}:

let
  updateScript = writeShellApplication {
    name = "update-tdlib";

    runtimeInputs = [
      jq
      common-updater-scripts
    ];

    text = ''
      commit_msg="^Update version to (?<v>\\\\d+.\\\\d+.\\\\d+)\\\\.$"
      commit=$(curl -s "https://api.github.com/repos/tdlib/td/commits?path=CMakeLists.txt" | jq -c "map(select(.commit.message | test(\"''${commit_msg}\"))) | first")

      rev=$(echo "$commit" | jq -r ".sha")
      version=$(echo "$commit" | jq -r ".commit.message | capture(\"''${commit_msg}\") | .v")

      update-source-version tdlib "$version" --rev="$rev"
    '';
  };
in

stdenv.mkDerivation {
  pname = "tdlib";
  version = "1.8.41";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";

    # The tdlib authors do not set tags for minor versions, but
    # external programs depending on tdlib constrain the minor
    # version, hence we set a specific commit with a known version.
    rev = "5b974c298d4ed551d3ad2c061ad7b8280d137c7e";
    hash = "sha256-1TyGv2yMjX75+ccZSox/2m6SMmwEZAkShIhLfCeNmZg=";
  };

  buildInputs = [
    gperf
    openssl
    readline
    zlib
  ];
  nativeBuildInputs = [ cmake ];

  # https://github.com/tdlib/td/issues/1974
  postPatch =
    ''
      substituteInPlace CMake/GeneratePkgConfig.cmake \
        --replace 'function(generate_pkgconfig' \
                  'include(GNUInstallDirs)
                   function(generate_pkgconfig' \
        --replace '\$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
        --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
      sed -i "/vptr/d" test/CMakeLists.txt
    '';

  passthru.updateScript = lib.getExe updateScript;

  meta = with lib; {
    description = "Cross-platform library for building Telegram clients";
    homepage = "https://core.telegram.org/tdlib/";
    license = [ licenses.boost ];
    platforms = platforms.unix;
    maintainers = [
      maintainers.vyorkin
      maintainers.vonfry
    ];
  };
}
