{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcs50";
  version = "11.0.2";

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "libcs50";
    rev = "v${finalAttrs.version}";
    hash = "sha256-A4CEU5wfwykVTDIsKZnQ8co+6RwBGYGZEZxRFzQTKBI=";
  };

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -R build/lib $out/lib
    cp -R build/include $out/include
    ln -sf $out/lib/libcs50.so.11.0.2 $out/lib/libcs50.so.11
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/cs50/libcs50";
    description = "CS50 Library for C";
    license = licenses.gpl3Only;
  };
})
