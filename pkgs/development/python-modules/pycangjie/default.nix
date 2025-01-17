{
  lib,
  fetchFromGitLab,
  pkg-config,
  libcangjie,
  sqlite,
  buildPythonPackage,
  cython,
  meson,
  ninja,
  cmake,
}:

buildPythonPackage rec {
  pname = "pycangjie";
  version = "1.5.0";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "cangjie";
    repo = "pycangjie";
    rev = version;
    hash = "sha256-REWX6u3Rc72+e5lIImBwV5uFoBBUTMM5BOfYdKIFL4k=";
  };

  preConfigure = ''
    (
      cd subprojects
      set -x
      cp -R --no-preserve=mode,ownership ${libcangjie.src} libcangjie
    )
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cython
    cmake
  ];

  buildInputs = [
    sqlite
  ];

  pythonImportsCheck = [ "cangjie" ];

  # `buildPythonApplication` skips checkPhase
  postInstallCheck = ''
    mesonCheckPhase
  '';

  meta = with lib; {
    description = "Python wrapper to libcangjie";
    homepage = "https://cangjians.github.io/projects/pycangjie/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.linquize ];
    platforms = platforms.all;
  };
}
