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
  version = "1.8.39";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";

    # The tdlib authors do not set tags for minor versions, but
    # external programs depending on tdlib constrain the minor
    # version, hence we set a specific commit with a known version.
    rev = "056963e48fa8d3f89556239c22d6ac843d3c8a5b";
    hash = "sha256-pQ+uYnyBTH4L6RW3MqAttx7K3z8fyEbzRy8JSjbBL98=";
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
    maintainers = [ maintainers.vyorkin ];
  };
}
