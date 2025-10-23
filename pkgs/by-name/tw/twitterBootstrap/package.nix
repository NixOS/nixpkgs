{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bootstrap";
  version = "5.3.8";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${finalAttrs.version}/bootstrap-${finalAttrs.version}-dist.zip";
    hash = "sha256-MljIc8vLHi2B9DdK/qLqZDfZ7ukHcEEHP9gd1XnFums=";
  };

  nativeBuildInputs = [ unzip ];

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r * $out/

    runHook postInstall
  '';

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = "https://getbootstrap.com/";
    license = lib.licenses.mit;
  };
})
