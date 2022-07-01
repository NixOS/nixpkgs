{ mkDerivation
, lib
, fetchFromGitHub
, cmake
, pkg-config
, withGstreamer ? true
, gst_all_1
}:

mkDerivation rec {
  pname = "qxmpp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "qxmpp-project";
    repo = pname;
    rev = "v${version}";
    sha256 = "1knpq1jkwk0lxdwczbmzf7qrjvlxba9yr40nbq9s5nqkcx6q1c3i";
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals withGstreamer [
    pkg-config
  ];
  buildInputs = lib.optionals withGstreamer (with gst_all_1; [
    gstreamer
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
  ]);
  cmakeFlags = [
    "-DBUILD_EXAMPLES=false"
    "-DBUILD_TESTS=false"
  ] ++ lib.optionals withGstreamer [
    "-DWITH_GSTREAMER=ON"
  ];

  meta = with lib; {
    description = "Cross-platform C++ XMPP client and server library";
    homepage = "https://github.com/qxmpp-project/qxmpp";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ astro ];
    platforms = with platforms; linux;
  };
}
