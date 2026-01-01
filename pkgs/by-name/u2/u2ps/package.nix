{
  lib,
  stdenv,
  fetchFromGitHub,
  ghostscript_headless,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u2ps";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "arsv";
    repo = "u2ps";
    rev = finalAttrs.version;
    hash = "sha256-sa0CL47PwYVDykxzF8KeWhz7HXAX6jZ0AcfecD+aFyg=";
  };

  buildInputs = [ ghostscript_headless ];

<<<<<<< HEAD
  meta = {
    description = "Unicode text to postscript converter";
    homepage = "https://github.com/arsv/u2ps";
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    description = "Unicode text to postscript converter";
    homepage = "https://github.com/arsv/u2ps";
    license = licenses.gpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    longDescription = ''
      U2ps is a text to postscript converter similar to a2ps,
      with emphasis on Unicode support.
    '';
    mainProgram = "u2ps";
<<<<<<< HEAD
    maintainers = [ lib.maintainers.athas ];
    platforms = lib.platforms.unix;
=======
    maintainers = [ maintainers.athas ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
