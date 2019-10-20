{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, wrapQtAppsHook
, qtbase, libuuid, libcap, uwsgi, grantlee, pcre
}:

stdenv.mkDerivation rec {
  pname = "cutelyst";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "cutelyst";
    repo = "cutelyst";
    rev = "v${version}";
    sha256 = "02jys32qkyksa2dmanyg4x0y5lh4ra0xbn2mfr2k84slrxbgjs1g";
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
