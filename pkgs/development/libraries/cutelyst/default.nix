{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, qtbase, libuuid, libcap, uwsgi, grantlee }:

stdenv.mkDerivation rec {
  name = "cutelyst-${version}";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "cutelyst";
    repo = "cutelyst";
    rev = "v${version}";
    sha256 = "0iamavr5gj213c8knrh2mynhn8wcrv83x6s46jq93x93kc5127ks";
  };

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];
  buildInputs = [ qtbase libuuid libcap uwsgi grantlee ];

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
