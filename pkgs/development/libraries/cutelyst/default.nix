{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, wrapQtAppsHook
, qtbase, libuuid, libcap, uwsgi, grantlee, pcre
}:

stdenv.mkDerivation rec {
  pname = "cutelyst";
  version = "2.14.2";

  src = fetchFromGitHub {
    owner = "cutelyst";
    repo = "cutelyst";
    rev = "v${version}";
    sha256 = "sha256-JUffOeUTeaZvEssP5hfSGipeRuQ7FzLF4bOizCFhe5o=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [
    qtbase
    grantlee
  ] ++ lib.optionals stdenv.isLinux [
    libuuid
    libcap
    uwsgi
    pcre
  ];

  cmakeFlags = [
    "-DPLUGIN_UWSGI=${if stdenv.isLinux then "ON" else "OFF"}" # Missing uwsgi symbols on Darwin
    "-DPLUGIN_STATICCOMPRESSED=ON"
    "-DPLUGIN_CSRFPROTECTION=ON"
    "-DPLUGIN_VIEW_GRANTLEE=ON"
  ];

  meta = with lib; {
    description = "C++ Web Framework built on top of Qt";
    homepage = "https://cutelyst.org/";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
