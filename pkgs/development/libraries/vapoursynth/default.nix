{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, makeWrapper
, runCommandCC, runCommand, vapoursynth, writeText, patchelf, buildEnv
, zimg, libass, python3, libiconv
, ApplicationServices
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth";
  version = "59";

  src = fetchFromGitHub {
    owner  = "vapoursynth";
    repo   = "vapoursynth";
    rev    = "R${version}";
    sha256 = "sha256-6w7GSC5ZNIhLpulni4sKq0OvuxHlTJRilBFGH5PQW8U=";
  };

  patches = [
    ./0001-Call-weak-function-to-allow-adding-preloaded-plugins.patch
  ];

  nativeBuildInputs = [ pkg-config autoreconfHook makeWrapper ];
  buildInputs = [
    zimg libass
    (python3.withPackages (ps: with ps; [ sphinx cython ]))
  ] ++ lib.optionals stdenv.isDarwin [ libiconv ApplicationServices ];

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

    # VapourSynth does not include any plugins by default
    # and emits a warning when the system plugin directory does not exist.
    mkdir $out/lib/vapoursynth
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A video processing framework with the future in mind";
    homepage    = "http://www.vapoursynth.com/";
    license     = licenses.lgpl21;
    platforms   = platforms.x86_64;
    maintainers = with maintainers; [ rnhmjoj sbruder tadeokondrak ];
  };
}
