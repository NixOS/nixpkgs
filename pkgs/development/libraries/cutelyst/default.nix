{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, wrapQtAppsHook
, qtbase, libuuid, libcap, uwsgi, grantlee, pcre
}:

stdenv.mkDerivation rec {
  name = "cutelyst-${version}";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "cutelyst";
    repo = "cutelyst";
    rev = "v${version}";
    sha256 = "09cgfpr2k1jp98h1ahxqm5lmv3qbk0bcxpqpill6n5wmq2c8kl8b";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapQtAppsHook ];
  buildInputs = [ qtbase libuuid libcap uwsgi grantlee pcre ];

  cmakeFlags = [
    "-DPLUGIN_UWSGI=ON"
    "-DPLUGIN_STATICCOMPRESSED=ON"
    "-DPLUGIN_CSRFPROTECTION=ON"
    "-DPLUGIN_VIEW_GRANTLEE=ON"
  ];

  preBuild = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:`pwd`/Cutelyst:`pwd`/EventLoopEPoll"
  '';

  postBuild = ''
    unset LD_LIBRARY_PATH
  '';

  meta = with lib; {
    description = "C++ Web Framework built on top of Qt";
    homepage = https://cutelyst.org/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fpletz ];
  };
}
