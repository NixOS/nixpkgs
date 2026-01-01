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

<<<<<<< HEAD
  meta = {
    description = "Faster version of Apple's linker";
    homepage = "https://github.com/michaeleisel/zld";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.rgnns ];
    platforms = lib.platforms.darwin;
=======
  meta = with lib; {
    description = "Faster version of Apple's linker";
    homepage = "https://github.com/michaeleisel/zld";
    license = licenses.mit;
    maintainers = [ maintainers.rgnns ];
    platforms = platforms.darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hydraPlatforms = [ ];
  };
}
