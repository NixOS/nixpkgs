{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, makeWrapper
, runCommandCC, runCommand, vapoursynth, writeText, patchelf, buildEnv
, zimg, libass, python3, libiconv
, ApplicationServices
, ocrSupport ? false, tesseract
, imwriSupport ? true, imagemagick
}:

with lib;

stdenv.mkDerivation rec {
  pname = "vapoursynth";
  version = "R52";

  src = fetchFromGitHub {
    owner  = "vapoursynth";
    repo   = "vapoursynth";
    rev    = version;
    sha256 = "1krfdzc2x2vxv4nq9kiv1c09hgj525qn120ah91fw2ikq8ldvmx4";
  };

  patches = [
    ./0001-Call-weak-function-to-allow-adding-preloaded-plugins.patch
  ];

  nativeBuildInputs = [ pkg-config autoreconfHook makeWrapper ];
  buildInputs = [
    zimg libass
    (python3.withPackages (ps: with ps; [ sphinx cython ]))
  ] ++ optionals stdenv.isDarwin [ libiconv ApplicationServices ]
    ++ optional ocrSupport   tesseract
    ++ optional imwriSupport imagemagick;

  configureFlags = [
    (optionalString (!ocrSupport)   "--disable-ocr")
    (optionalString (!imwriSupport) "--disable-imwri")
  ];

  enableParallelBuilding = true;

  passthru = rec {
    # If vapoursynth is added to the build inputs of mpv and then
    # used in the wrapping of it, we want to know once inside the
    # wrapper, what python3 version was used to build vapoursynth so
    # the right python3.sitePackages will be used there.
    inherit python3;

    withPlugins = import ./plugin-interface.nix {
      inherit lib python3 buildEnv writeText runCommandCC stdenv runCommand
        vapoursynth makeWrapper withPlugins;
    };
  };

  postInstall = ''
    wrapProgram $out/bin/vspipe \
        --prefix PYTHONPATH : $out/${python3.sitePackages}
  '';

  meta = with lib; {
    description = "A video processing framework with the future in mind";
    homepage    = "http://www.vapoursynth.com/";
    license     = licenses.lgpl21;
    platforms   = platforms.x86_64;
    maintainers = with maintainers; [ rnhmjoj sbruder tadeokondrak ];
  };

}
