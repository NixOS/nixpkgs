{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
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
    pkgconfig
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
    description = "Various packaging tools and scripts for LXQt applications";
    homepage = "https://github.com/lxqt/lxqt-build-tools";
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
