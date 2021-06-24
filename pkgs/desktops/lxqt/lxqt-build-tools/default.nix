{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, pcre
, qtbase
, glib
, perl
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-build-tools";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0zhcv6cbdn9fr5lpglz26gzssbxkpi824sgc0g7w3hh1z6nqqf8l";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    setupHook
  ];

  buildInputs = [
    qtbase
    glib
    pcre
  ];

  propagatedBuildInputs = [
    perl # needed by LXQtTranslateDesktop.cmake
  ];

  setupHook = ./setup-hook.sh;

  # We're dependent on this macro doing add_definitions in most places
  # But we have the setup-hook to set the values.
  postInstall = ''
    rm $out/share/cmake/lxqt-build-tools/modules/LXQtConfigVars.cmake
    cp ${./LXQtConfigVars.cmake} $out/share/cmake/lxqt-build-tools/modules/LXQtConfigVars.cmake
  '';

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-build-tools";
    description = "Various packaging tools and scripts for LXQt applications";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
