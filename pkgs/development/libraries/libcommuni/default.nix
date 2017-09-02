{ stdenv, fetchFromGitHub
, qtbase, qtdeclarative, qmake, which
}:

stdenv.mkDerivation rec {
  name = "libcommuni-${version}";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "communi";
    repo = "libcommuni";
    rev = "v${version}";
    sha256 = "15crqc7a4kwrfbxs121rpdysw0694hh7dr290gg7pm61akvnrqcm";
  };

  buildInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ qmake which ];

  enableParallelBuilding = true;

  dontUseQmakeConfigure = true;
  configureFlags = "-config release";
  preConfigure = ''
    sed -i -e 's|/bin/pwd|pwd|g' configure
  '';

  doCheck = true;

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = "rm -rf lib";

  meta = with stdenv.lib; {
    description = "A cross-platform IRC framework written with Qt";
    homepage = https://communi.github.io;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ hrdinka ];
  };
}
