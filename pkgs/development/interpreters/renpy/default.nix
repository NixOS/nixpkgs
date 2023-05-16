{ lib, stdenv, fetchFromGitHub, python3, pkg-config, SDL2
, libpng, ffmpeg, freetype, glew, libGL, libGLU, fribidi, zlib
, makeWrapper
}:

let
  # https://renpy.org/doc/html/changelog.html#versioning
  # base_version is of the form major.minor.patch
  # vc_version is of the form YYMMDDCC
  # version corresponds to the tag on GitHub
<<<<<<< HEAD
  base_version = "8.1.1";
  vc_version = "23060707";
=======
  base_version = "8.0.3";
  vc_version = "22090809";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in stdenv.mkDerivation rec {
  pname = "renpy";

  version = "${base_version}.${vc_version}";

  src = fetchFromGitHub {
    owner = "renpy";
    repo = "renpy";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-aJ/MobZ6SNBYRC/EpUxAMLJ3pwK6PC92DV0YL/LF5Ew=";
=======
    sha256 = "sha256-0/wkUk7PMPbBSGzDuSd82yxRzvAYxkbEhM5LTVt4bMA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    python3.pkgs.cython
<<<<<<< HEAD
    python3.pkgs.setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    SDL2 libpng ffmpeg freetype glew libGLU libGL fribidi zlib
  ] ++ (with python3.pkgs; [
<<<<<<< HEAD
    python pygame_sdl2 tkinter future six pefile requests ecdsa
=======
    python pygame_sdl2 tkinter future six pefile requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ]);

  RENPY_DEPS_INSTALL = lib.concatStringsSep "::" (map (path: path) [
    SDL2 SDL2.dev libpng ffmpeg.lib freetype glew.dev libGLU libGL fribidi zlib
  ]);

  enableParallelBuilding = true;

  patches = [
<<<<<<< HEAD
=======
    ./renpy-system-fribidi.diff
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ./shutup-erofs-errors.patch
  ];

  postPatch = ''
<<<<<<< HEAD
    cp tutorial/game/tutorial_director.rpy{m,}

    cat > renpy/vc_version.py << EOF
    version = '${version}'
    official = False
    nightly = False
    # Look at https://renpy.org/latest.html for what to put.
    version_name = 'Where No One Has Gone Before'
=======
    substituteInPlace module/setup.py \
      --replace "@fribidi@" "${fribidi.dev}"

    cp tutorial/game/tutorial_director.rpy{m,}

    cat > renpy/vc_version.py << EOF
    vc_version = ${vc_version}
    official = False
    nightly = False
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    EOF
  '';

  buildPhase = with python3.pkgs; ''
    runHook preBuild
    ${python.pythonForBuild.interpreter} module/setup.py build --parallel=$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = with python3.pkgs; ''
    runHook preInstall

<<<<<<< HEAD
    ${python.pythonForBuild.interpreter} module/setup.py install_lib -d $out/${python.sitePackages}
=======
    ${python.pythonForBuild.interpreter} module/setup.py install --prefix=$out
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mkdir -p $out/share/renpy
    cp -vr sdk-fonts gui launcher renpy the_question tutorial renpy.py $out/share/renpy

    makeWrapper ${python.interpreter} $out/bin/renpy \
      --set PYTHONPATH "$PYTHONPATH:$out/${python.sitePackages}" \
      --add-flags "$out/share/renpy/renpy.py"

    runHook postInstall
  '';

  env.NIX_CFLAGS_COMPILE = with python3.pkgs; "-I${pygame_sdl2}/include/${python.libPrefix}";

  meta = with lib; {
    description = "Visual Novel Engine";
    homepage = "https://renpy.org/";
    changelog = "https://renpy.org/doc/html/changelog.html";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ shadowrz ];
  };

  passthru = { inherit base_version vc_version; };
}
