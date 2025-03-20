{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsNoGuiHook
, qtbase
, qca
, withGstreamer ? true
, gst_all_1
, withOmemo ? true
, libomemo-c
}:

stdenv.mkDerivation rec {
  pname = "qxmpp";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "qxmpp-project";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-M3F4tNIO3RvDxk/lce8/J6kmQtnsGLILQ15uEzgyfds=";
  };

  nativeBuildInputs = [
    cmake wrapQtAppsNoGuiHook
  ] ++ lib.optionals (withGstreamer || withOmemo) [
    pkg-config
  ];
  buildInputs = lib.optionals withGstreamer (with gst_all_1; [
    gstreamer
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
  ]) ++ lib.optionals withOmemo [
    qtbase
    qca
    libomemo-c
  ];
  cmakeFlags = [
    "-DBUILD_EXAMPLES=false"
    "-DBUILD_TESTS=false"
  ] ++ lib.optionals withGstreamer [
    "-DWITH_GSTREAMER=ON"
  ] ++ lib.optionals withOmemo [
    "-DBUILD_OMEMO=ON"
  ];

  meta = with lib; {
    description = "Cross-platform C++ XMPP client and server library";
    homepage = "https://github.com/qxmpp-project/qxmpp";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ astro ];
    platforms = with platforms; linux;
  };
}
