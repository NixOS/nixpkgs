{ lib
, gcc13Stdenv
, fetchFromGitHub
, cmake
, qt5
}:

# Barely compiles with GCC 13; might compile with newer ones with a little effort.
gcc13Stdenv.mkDerivation {
  pname = "ts3-crosstalk";
  version = "1.6.3.111601-unstable-2024-04-22";

  src = fetchFromGitHub {
    # Upstream is unresponsive, so until # https://github.com/thorwe/CrossTalk/pull/60
    # is merged, point at my(@Atemu) fork
    owner = "Atemu";
    repo = "CrossTalk";
    rev = "75b9194d2ad19b7bc38a61562db0fa9d9fc0f011";
    hash = "sha256-PVOsyeaG2FCp5DbgK+LOuPSeMwDdnXYSegJR4/tE+IA=";
    fetchSubmodules = true;
  };

  outputs = [ "ts3_plugin" "out" ];

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ qt5.qtbase ];

  installPhase = ''
    runHook preInstall

    echo "Use `teamspeak_client.override { ts3Plugins = [ pkgs.ts3-crosstalk ]; }`" > $out

    install libCrossTalk.so -Dt $ts3_plugin/

    runHook postInstall
  '';

  dontWrapQtApps = true;

  meta = {
    description = "A Teamspeak 3 plugin that enhances the general audio experience and provides advanced features for commanders";
    homepage = "https://github.com/thorwe/CrossTalk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atemu ];
    mainProgram = "ts3-crosstalk";
    platforms = lib.platforms.all;
  };
}
