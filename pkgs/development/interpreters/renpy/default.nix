{ lib, stdenv, fetchFromGitHub, python3, pkg-config, SDL2
, libpng, ffmpeg, freetype, glew, libGL, libGLU, fribidi, zlib
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "renpy";

  # https://renpy.org/doc/html/changelog.html#versioning
  # base_version is of the form major.minor.patch
  # vc_version is of the form YYMMDDCC
  # version corresponds to the tag on GitHub
  base_version = "8.0.3";
  vc_version = "22090809";
  version = "${base_version}.${vc_version}";

  src = fetchFromGitHub {
    owner = "renpy";
    repo = "renpy";
    rev = version;
    sha256 = "sha256-0/wkUk7PMPbBSGzDuSd82yxRzvAYxkbEhM5LTVt4bMA=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    python3.pkgs.cython
  ];

  buildInputs = [
    SDL2 libpng ffmpeg freetype glew libGLU libGL fribidi zlib
  ] ++ (with python3.pkgs; [
    python pygame_sdl2 tkinter future six pefile requests
  ]);

  RENPY_DEPS_INSTALL = lib.concatStringsSep "::" (map (path: path) [
    SDL2 SDL2.dev libpng ffmpeg.lib freetype glew.dev libGLU libGL fribidi zlib
  ]);

  enableParallelBuilding = true;

  patches = [
    ./renpy-system-fribidi.diff
    ./shutup-erofs-errors.patch
  ];

  postPatch = ''
    substituteInPlace module/setup.py \
      --replace "@fribidi@" "${fribidi}"

    cp tutorial/game/tutorial_director.rpy{m,}

    cat > renpy/vc_version.py << EOF
    vc_version = ${vc_version}
    official = False
    nightly = False
    EOF
  '';

  buildPhase = with python3.pkgs; ''
    runHook preBuild
    ${python.interpreter} module/setup.py build --parallel=$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = with python3.pkgs; ''
    runHook preInstall

    ${python.interpreter} module/setup.py install --prefix=$out
    mkdir -p $out/share/renpy
    cp -vr sdk-fonts gui launcher renpy the_question tutorial renpy.py $out/share/renpy

    makeWrapper ${python.interpreter} $out/bin/renpy \
      --set PYTHONPATH "$PYTHONPATH:$out/${python.sitePackages}" \
      --add-flags "$out/share/renpy/renpy.py"

    runHook postInstall
  '';

  NIX_CFLAGS_COMPILE = with python3.pkgs; "-I${pygame_sdl2}/include/${python.libPrefix}";

  meta = with lib; {
    description = "Visual Novel Engine";
    homepage = "https://renpy.org/";
    changelog = "https://renpy.org/doc/html/changelog.html";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ shadowrz ];
  };
}
