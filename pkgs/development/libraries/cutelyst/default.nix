{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, wrapQtAppsHook
, qtbase, libuuid, libcap, uwsgi, grantlee, pcre
}:

stdenv.mkDerivation rec {
  pname = "cutelyst";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "cutelyst";
    repo = "cutelyst";
    rev = "v${version}";
    sha256 = "1c4cjzx6jkqlblcfc7pkx66py43576y6rky19j7rjiap724q2yk9";
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
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}`pwd`/Cutelyst:`pwd`/EventLoopEPoll"
  '';

  postBuild = ''
    unset LD_LIBRARY_PATH
  '';

  meta = with lib; {
    description = "C++ Web Framework built on top of Qt";
    homepage = "https://cutelyst.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fpletz ];
  };
}
