{ lib, stdenv, cmake, fetchFromGitHub, makeWrapper, qt6, cryptopp, minizip-ng
, pkg-config, rapidjson, }:
stdenv.mkDerivation (finalAttrs: {
  pname = "vpkedit";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "craftablescience";
    repo = "VPKEdit";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-akg8+bj1z2JAfdKOUMsN9zJF2HCae7DUg9S6w6cldTM=";
    fetchSubmodules = true;
  };

  cmakeFlags = [ "-DVPKEDIT_BUILD_LIBC=OFF" ];
  patches = [ ./pkg-config.diff ./install.diff ./desktop.diff ];

  buildInputs = with qt6;
    [ qtbase qttools ] ++ [ cryptopp minizip-ng pkg-config rapidjson ];

  nativeBuildInputs = [ makeWrapper qt6.wrapQtAppsHook cmake ];

  postInstall = ''
    mkdir "$out/bin"
    ln -s "$out/lib/vpkedit/vpkedit" "$out/bin/vpkedit"
    ln -s "$out/lib/vpkedit/vpkeditcli" "$out/bin/vpkeditcli"
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
