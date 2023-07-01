{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation ( finalAttrs: {
  pname = "blst";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "supranational";
    repo = "blst";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xero1aTe2v4IhWIJaEDUsVDOfE77dOV5zKeHWntHogY=";
  };

  buildPhase = ''
    runHook preBuild

    ./build.sh

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp ./libblst.a $out/lib/

    runHook postInstall
  '';

  doCheck = true;

  meta = with lib; {
    description = "Multilingual BLS12-381 signature library";
    homepage = "https://github.com/supranational/blst";
    license = licenses.isc;
    maintainers = with maintainers; [ iquerejeta yvan-sraka ];
    platforms = platforms.all;
  };
})
