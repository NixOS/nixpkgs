{ stdenv, fetchFromGitHub, qtbase, qtdeclarative, qmakeHook, which
}:

stdenv.mkDerivation rec {
  name = "libcommuni-${version}";
  version = "2016-08-17";

  src = fetchFromGitHub {
    owner = "communi";
    repo = "libcommuni";
    rev = "dedba6faf57c31c8c70fd563ba12d75a9caee8a3";
    sha256 = "0wvs53z34vfs5xlln4a6sbd4981svag89xm0f4k20mb1i052b20i";
  };

  buildInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ qmakeHook which ];

  enableParallelBuilding = true;

  dontUseQmakeConfigure = true;
  configureFlags = "-config release";
  preConfigure = ''
    sed -i -e 's|/bin/pwd|pwd|g' configure
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A cross-platform IRC framework written with Qt";
    homepage = https://communi.github.io;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ hrdinka ];
  };
}
