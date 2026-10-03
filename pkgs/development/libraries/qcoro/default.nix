{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libpthread-stubs,
  qtbase,
  qtwebsockets,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "qcoro";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "danvratil";
    repo = "qcoro";
    rev = "v${version}";
    sha256 = "sha256-+uArJ9wuq/Cu8/P81xktPLAs6GH13RFepqhdqOof0Jo=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
  ];

  buildInputs = [
    qtbase
    qtwebsockets
    libpthread-stubs
  ];

  meta = {
    description = "Library for using C++20 coroutines in connection with certain asynchronous Qt actions";
    homepage = "https://github.com/danvratil/qcoro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ smitop ];
    platforms = lib.platforms.linux;
  };
}
