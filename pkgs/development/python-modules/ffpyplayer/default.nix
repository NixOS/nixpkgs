{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchurl,
  stdenv,
}:
let
  wheel =
    if stdenv.hostPlatform.isDarwin then
      "macosx_10_13_universal2.whl"
    else if stdenv.hostPlatform.isAarch64 then
      "manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
    else
      "manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
in
buildPythonPackage rec {
  pname = "ffpyplayer";
  version = "4.5.3";
  format = "wheel";
  disabled = pythonOlder "3.9";

  src = fetchurl {
    url = "https://github.com/matham/ffpyplayer/releases/download/v${version}/ffpyplayer-${version}-cp313-cp313-${wheel}";
    hash =
      if stdenv.hostPlatform.isDarwin then
        "sha256-RBiI9Ct229fDAF9E1xRfcTodjOIzUbvEgLn6BeRmKvs="
      else if stdenv.hostPlatform.isAarch64 then
        "sha256-PgEswclDVwAJ+tAkpnW99Dsx6OHQwHCXFeYRvfWrOVk="
      else
        "sha256-WGsEzVmxvDp1nZdy3igRckgOFmd4aTR0JJrh4SVKQn8=";
  };

  pythonImportsCheck = [ "ffpyplayer" ];

  meta = with lib; {
    description = "A cython implementation of an ffmpeg based player.";
    homepage = "https://matham.github.io/ffpyplayer/index.html";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ iofq ];
  };
}
