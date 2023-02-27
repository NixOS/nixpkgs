{ stdenv, lib, substituteAll, fetchFromGitHub, buildPythonPackage, python, pkg-config, libX11
, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, libpng, libjpeg, portmidi, freetype, fontconfig
, AppKit
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "pygame";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    # Unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation. The documentation
    # has such files and will be removed.
    sha256 = "sha256-CST51mTFytCAubx69nie6Vu99DRIVUEW6uTPa4APcTE=";
    postFetch = "rm -rf $out/docs/reST";
  };

  patches = [
    # Patch pygame's dependency resolution to let it find build inputs
    (substituteAll {
      src = ./fix-dependency-finding.patch;
      buildinputs_include = builtins.toJSON (builtins.concatMap (dep: [
        "${lib.getDev dep}/"
        "${lib.getDev dep}/include"
        "${lib.getDev dep}/include/SDL2"
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
    AppKit
  ];

  preConfigure = ''
    ${python.pythonForBuild.interpreter} buildconfig/config.py
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
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
    # fatal error: longintrepr.h: No such file or directory.
    broken = pythonAtLeast "3.11"; # At 2022-02-27
  };
}
