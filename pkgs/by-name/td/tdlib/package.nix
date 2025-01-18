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
  buildPackages,
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
  version = "1.8.42";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";

    # The tdlib authors do not set tags for minor versions, but
    # external programs depending on tdlib constrain the minor
    # version, hence we set a specific commit with a known version.
    rev = "ef580cd3dd0e5223c2be503342dc29e128be866e";
    hash = "sha256-k1YQpQXYmEdoiyWeAcj2KRU+BcWuWbHpd4etxLspEoo=";
  };

  buildInputs = [
    openssl
    readline
    zlib
  ];

  nativeBuildInputs = [
    cmake
    gperf
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    cmake -B native-build \
      -DCMAKE_C_COMPILER=$CC_FOR_BUILD \
      -DCMAKE_CXX_COMPILER=$CXX_FOR_BUILD \
      -DCMAKE_AR=$(command -v $AR_FOR_BUILD) \
      -DCMAKE_RANLIB=$(command -v $RANLIB_FOR_BUILD) \
      -DCMAKE_STRIP=$(command -v $STRIP_FOR_BUILD) \
      -DTD_GENERATE_SOURCE_FILES=ON .
    cmake --build native-build -j $NIX_BUILD_CORES
  '';

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
