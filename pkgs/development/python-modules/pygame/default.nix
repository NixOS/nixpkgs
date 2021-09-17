{ stdenv, lib, substituteAll, fetchPypi, buildPythonPackage, python, pkg-config, libX11
, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, libpng, libjpeg, portmidi, freetype, fontconfig
, AppKit, CoreMIDI
}:

buildPythonPackage rec {
  pname = "pygame";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b1e7b63f47aafcdd8849933b206778747ef1802bd3d526aca45ed77141e4001";
  };

  patches = [
    # Patch pygame's dependency resolution to let it find build inputs
    (substituteAll {
      src = ./fix-dependency-finding.patch;
      buildinputs_include = builtins.toJSON (builtins.concatMap (dep: [
        "${lib.getDev dep}/"
        "${lib.getDev dep}/include"
      ]) buildInputs);
      buildinputs_lib = builtins.toJSON (builtins.concatMap (dep: [
        "${lib.getLib dep}/"
        "${lib.getLib dep}/lib"
      ]) buildInputs);
    })
  ];

  postPatch = ''
    substituteInPlace src_py/sysfont.py \
      --replace 'path="fc-list"' 'path="${fontconfig}/bin/fc-list"' \
      --replace /usr/X11/bin/fc-list ${fontconfig}/bin/fc-list
  '';

  nativeBuildInputs = [
    pkg-config SDL2
  ];

  buildInputs = [
    SDL2 SDL2_image SDL2_mixer SDL2_ttf libpng libjpeg
    portmidi libX11 freetype
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit CoreMIDI
  ];

  preConfigure = ''
    LOCALBASE=/ ${python.interpreter} buildconfig/config.py
  '';

  checkPhase = ''
    runHook preCheck

    # No audio or video device in test environment
    export SDL_VIDEODRIVER=dummy
    export SDL_AUDIODRIVER=disk
    export SDL_DISKAUDIOFILE=/dev/null

    ${python.interpreter} -m pygame.tests -v --exclude opengl,timing --time_out 300

    runHook postCheck
  '';
  pythonImportsCheck = [ "pygame" ];

  meta = with lib; {
    description = "Python library for games";
    homepage = "https://www.pygame.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ angustrau ];
    platforms = platforms.unix;
  };
}
