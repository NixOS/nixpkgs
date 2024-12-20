{ mkDerivation
, lib
, fetchFromGitHub
, cmake
, pkg-config
, withGstreamer ? true
, gst_all_1
, withOmemo ? true
, qca-qt5
, libomemo-c
}:

mkDerivation rec {
  pname = "qxmpp";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "qxmpp-project";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xqQUDFZgnBpUIv8kYvsNrJrIF259p3CccNn7u4vpxmY=";
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals (withGstreamer || withOmemo) [
    pkg-config
  ];
  buildInputs = lib.optionals withGstreamer (with gst_all_1; [
    gstreamer
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
  ]) ++ lib.optionals withOmemo [
    qca-qt5
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
