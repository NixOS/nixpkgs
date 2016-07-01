{ fetchgit, qtbase, qmakeHook, which, stdenv
}:

stdenv.mkDerivation rec {
  name = "libcommuni-${version}";
  version = "2016-03-23";

  src = fetchgit {
    url = "https://github.com/communi/libcommuni.git";
    rev = "6a5110b25e2838e7dc2c62d16b9fd06d12beee7e";
    sha256 = "184ah5xqg5pgy8h6fyyz2k0vak1fmhrcidwz828yl4lsvz1vjqh1";
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ qmakeHook which ];

  enableParallelBuild = true;

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
