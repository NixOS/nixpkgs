{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, pcre
, qtbase
, glib
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-build-tools";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1wf6mhcfgk64isy7bk018szlm18xa3hjjnmhpcy2whnnjfq0jal6";
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
