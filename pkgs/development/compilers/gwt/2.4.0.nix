{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "gwt-java";
  version = "2.4.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/google-web-toolkit/gwt-${version}.zip";
    sha256 = "1gvyg00vx7fdqgfl2w7nhql78clg3abs6fxxy7m03pprdm5qmm17";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out
    unzip $src
    mv gwt-2.4.0 $out/bin
  '';

  meta = {
    homepage = "https://www.gwtproject.org/";
    description = "A development toolkit for building and optimizing complex browser-based applications";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
