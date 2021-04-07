{ lib, stdenv, fetchFromGitHub
, qtbase, qtdeclarative, qmake, which
}:

stdenv.mkDerivation rec {
  pname = "libcommuni";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "communi";
    repo = "libcommuni";
    rev = "v${version}";
    sha256 = "sha256-ABvrMoOVSycbQ8iRDzi7zkFnuSgHMMBgm9cDUWlD4uc=";
  };

  buildInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ qmake which ];

  enableParallelBuilding = true;

  dontUseQmakeConfigure = true;
  configureFlags = [ "-config" "release" ];

  dontWrapQtApps = true;

  preConfigure = ''
    sed -i -e 's|/bin/pwd|pwd|g' configure
  '';

  # The tests fail on darwin because of install_name if they run
  # before the frameworks are installed.
  doCheck = false;
  doInstallCheck = true;
  installCheckTarget = "check";

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = "rm -rf lib";

  meta = with lib; {
    description = "A cross-platform IRC framework written with Qt";
    homepage = "https://communi.github.io";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ hrdinka ];
  };
}
