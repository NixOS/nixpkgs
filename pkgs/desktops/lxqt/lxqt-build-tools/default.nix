{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, pcre, qtbase, glib }:

mkDerivation rec {
  pname = "lxqt-build-tools";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0i7m9s4g5rsw28vclc9nh0zcapx85cqfwxkx7rrw7wa12svy7pm2";
  };

  nativeBuildInputs = [ cmake pkgconfig setupHook ];

  buildInputs = [ qtbase glib pcre ];

  setupHook = ./setup-hook.sh;

  # We're dependent on this macro doing add_definitions in most places
  # But we have the setup-hook to set the values.
  postInstall = ''
    rm $out/share/cmake/lxqt-build-tools/modules/LXQtConfigVars.cmake
    cp ${./LXQtConfigVars.cmake} $out/share/cmake/lxqt-build-tools/modules/LXQtConfigVars.cmake
  '';

  meta = with lib; {
    description = "Various packaging tools and scripts for LXQt applications";
    homepage = https://github.com/lxqt/lxqt-build-tools;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
