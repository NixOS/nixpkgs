{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, qtbase, libuuid, libcap, uwsgi, grantlee, pcre
}:

stdenv.mkDerivation rec {
  name = "cutelyst-${version}";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "cutelyst";
    repo = "cutelyst";
    rev = "v${version}";
    sha256 = "092qzam3inmj3kvn1s0ygwf3jcikifzkk5hv02b5ym18nqz1025d";
  };

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];
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

  postInstall = ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --set QT_PLUGIN_PATH '${qtbase}/${qtbase.qtPluginPrefix}'
    done
  '';

  meta = with lib; {
    description = "C++ Web Framework built on top of Qt";
    homepage = https://cutelyst.org/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fpletz ];
  };
}
