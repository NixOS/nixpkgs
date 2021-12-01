{ lib
, stdenv
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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1hb04zgpalxv6da3myf1dxsbjix15dczzfq8a24g5dg2zfhwpx21";
  };

  # Nix clang on darwin identifies as 'Clang', not 'AppleClang'
  # Without this, dependants fail to link.
  postPatch = ''
    substituteInPlace cmake/modules/LXQtCompilerSettings.cmake \
      --replace AppleClang Clang
  '';

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
