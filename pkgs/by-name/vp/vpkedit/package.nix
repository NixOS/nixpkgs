{ lib, stdenv, cmake, fetchFromGitHub, makeWrapper, qt6, cryptopp, minizip-ng
, pkg-config, rapidjson, }:
stdenv.mkDerivation (finalAttrs: {
  pname = "vpkedit";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "craftablescience";
    repo = "VPKEdit";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-k5WP8U/rkhIHtb03dWZwE3813rPZEPMCy3FeBGLSbP0=";
    fetchSubmodules = true;
    deepClone = true;
  };

  patches = [ ./pkg-config.diff ./install.diff ./desktop.diff ];

  postPatch = ''
    sed -i '5s/^/#include <algorithm>/' "src/shared/thirdparty/sourcepp/src/fgdpp/fgdpp.cpp"
  '';

  buildInputs = with qt6;
    [ qtbase qttools ] ++ [ cryptopp minizip-ng pkg-config rapidjson ];

  nativeBuildInputs = [ makeWrapper qt6.wrapQtAppsHook cmake ];

  postInstall = ''
    ln -sf "$out/lib/vpkedit/vpkedit" "$out/bin/vpkedit"
    ln -sf "$out/lib/vpkedit/vpkeditcli" "$out/bin/vpkeditcli"
  '';

  meta = {
    description =
      "A CLI/GUI tool to create, read, and write several pack file formats.";
    license = lib.licenses.mit;
    homepage = "https://github.com/craftablescience/VPKEdit/";
    mainProgram = "vpkedit";
    maintainers = with lib.maintainers; [ hurricanepootis ];
  };
})
