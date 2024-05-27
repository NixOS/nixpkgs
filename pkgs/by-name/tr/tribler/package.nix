{
  lib,
  stdenv,
  fetchurl,
  fetchPypi,
  python3,
  makeWrapper,
  libtorrent-rasterbar-1_2_x,
  qt5,
  nix-update-script,
}:

let
  libtorrent = (python3.pkgs.toPythonModule (libtorrent-rasterbar-1_2_x)).python;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tribler";
  version = "7.14.0";

  src = fetchurl {
    url = "https://github.com/Tribler/tribler/releases/download/v${finalAttrs.version}/Tribler-${finalAttrs.version}.tar.xz";
    hash = "sha256-fQJOs9P4y71De/+svmD7YZ4+tm/bC3rspm7SbOHlSR4=";
  };

  nativeBuildInputs = [
    python3.pkgs.wrapPython
    makeWrapper
    # we had a "copy" of this in tribler's makeWrapper
    # but it went out of date and broke, so please just use it directly
    qt5.wrapQtAppsHook
  ];

  buildInputs = [ python3.pkgs.python ];

  pythonPath =
    [ libtorrent ]
    ++ (with python3.pkgs; [
      # requirements-core.txt
      aiohttp
      aiohttp-apispec
      anyio
      chardet
      configobj
      cryptography
      decorator
      faker
      libnacl
      lz4
      marshmallow
      netifaces
      networkx
      pony
      psutil
      pyasn1
      pydantic_1
      pyopenssl
      pyyaml
      sentry-sdk
      service-identity
      yappi
      yarl
      bitarray
      filelock
      (pyipv8.overrideAttrs (p: rec {
        version = "2.10.0";
        src = fetchPypi {
          inherit (p) pname;
          inherit version;
          hash = "sha256-yxiXBxBiPokequm+vjsHIoG9kQnRnbsOx3mYOd8nmiU=";
        };
      }))
      file-read-backwards
      brotli
      human-readable
      # requirements.txt
      pillow
      pyqt5
      #pyqt5-sip
      pyqtgraph
      pyqtwebengine
    ]);

  installPhase = ''
    mkdir -pv $out
    # Nasty hack; call wrapPythonPrograms to set program_PYTHONPATH.
    wrapPythonPrograms
    cp -prvd ./* $out/
    makeWrapper ${python3.pkgs.python}/bin/python $out/bin/tribler \
        --set _TRIBLERPATH "$out/src" \
        --set PYTHONPATH $out/src/tribler-core:$out/src/tribler-common:$out/src/tribler-gui:$program_PYTHONPATH \
        --set NO_AT_BRIDGE 1 \
        --chdir "$out/src" \
        --add-flags "-O $out/src/run_tribler.py"

    mkdir -p $out/share/applications $out/share/icons
    cp $out/build/debian/tribler/usr/share/applications/org.tribler.Tribler.desktop $out/share/applications/
    cp $out/build/debian/tribler/usr/share/pixmaps/tribler_big.xpm $out/share/icons/tribler.xpm
    mkdir -p $out/share/copyright/tribler
    mv $out/LICENSE $out/share/copyright/tribler
  '';

  shellHook = ''
    wrapPythonPrograms || true
    export QT_QPA_PLATFORM_PLUGIN_PATH=$(echo ${qt5.qtbase.bin}/lib/qt-*/plugins/platforms)
    export PYTHONPATH=./tribler-core:./tribler-common:./tribler-gui:$program_PYTHONPATH
    export QT_PLUGIN_PATH="${qt5.qtsvg.bin}/${qt5.qtbase.qtPluginPrefix}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Decentralised P2P filesharing client based on the Bittorrent protocol";
    mainProgram = "tribler";
    homepage = "https://www.tribler.org/";
    changelog = "https://github.com/Tribler/tribler/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      xvapx
      viric
      mkg20001
    ];
    platforms = lib.platforms.linux;
  };
})
