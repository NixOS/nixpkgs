{ lib, stdenv, fetchFromGitHub, libtiff, libjpeg, nix-update-script, zlib }:

stdenv.mkDerivation rec {
  pname = "lcms2";
  version = "2.14";

  outputs = [ "bin" "dev" "out" ];

  src = fetchFromGitHub {
    owner = "mm2";
    repo = "Little-CMS";
    rev = "lcms${version}";
    sha256 = "sha256-E4D25wRUPNvcaCR9Hx72Hfsb3sc7P5yb8EgfExFxZFg=";
  };

  propagatedBuildInputs = [ libtiff libjpeg zlib ];

  # See https://trac.macports.org/ticket/60656
  LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-Wl,-w";

  passthru.updateScript = nix-update-script {
    attrPath = pname;
    extraArgs = [ "--version-regex" "lcms([0-9.]+)" ];
  };

  meta = with lib; {
    description = "Color management engine";
    homepage = "https://www.littlecms.com";
    changelog = "https://github.com/mm2/Little-CMS/blob/lcms${version}/ChangeLog";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
