{ stdenv
, clangStdenv
, lib
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, cmake
, ninja
, openssl
, pkg-config
, boost
, python3
, SDL2
, dbus
, zlib
, curl
, discord-rpc
}:

clangStdenv.mkDerivation rec {
  pname = "vita3k";
  version = "unstable-2024-03-05";

  src = fetchFromGitHub {
    owner = "Vita3K";
    repo = "Vita3K";
    rev = "22595c5060298e246bbef02eb70d32752259ee09";
    fetchSubmodules = true;
    hash = "sha256-/3oDBVCEO2Fv6f5S1Sc+iXmc+h4M5yhoz1ewuwzjiWA=";
  };

  patches = [ ./patches/external/CMakeLists.txt.patch ];
  postPatch = ''
    # Don't force the need for a static boost
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(Boost_USE_STATIC_LIBS ON)' 'set(Boost_USE_STATIC_LIBS OFF)'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    openssl
    boost
    python3
    SDL2
    dbus
    zlib
    curl
    discord-rpc
  ];

  # This thrashes ir/opt/* source code paths in external/dynarmic/src/dynarmic/CMakeLists.txt
  dontFixCmake = true;

  cmakeFlags = [
    "-DUSE_VITA3K_UPDATE=OFF" # updates via nix
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp -r bin $out/lib/${pname}
    ln -s $out/{lib/${pname},bin}/Vita3K
    install -Dm644 ../data/image/icon.png $out/share/icons/hicolor/128x128/apps/${pname}.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Vita3K";
      exec = "Vita3K";
      icon = pname;
    })
  ];

  meta = with lib; {
    description = "Experimental PlayStation Vita emulator";
    homepage = "https://vita3k.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ annaaurora ];
  };
}
