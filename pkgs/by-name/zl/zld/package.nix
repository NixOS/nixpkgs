{
  stdenv,
  lib,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "zld";
  version = "1.3.4";
  src = fetchzip {
    url = "https://github.com/michaeleisel/zld/releases/download/${version}/zld.zip";
    sha256 = "sha256-w1Pe96sdCbrfYdfBpD0BBXu7cFdW3cpo0PCn1+UyZI8=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp zld $out/bin/
  '';

  meta = {
    description = "Faster version of Apple's linker";
    homepage = "https://github.com/michaeleisel/zld";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.rgnns ];
    platforms = lib.platforms.darwin;
    hydraPlatforms = [ ];
  };
}
