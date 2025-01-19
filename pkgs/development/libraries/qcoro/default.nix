{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libpthreadstubs,
  qtbase,
  qtwebsockets,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "qcoro";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "danvratil";
    repo = "qcoro";
    rev = "v${version}";
    sha256 = "sha256-teRuWtNR8r/MHZhqphazr7Jmn43qsHGv9eXOGrhSND0=";
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
    libpthreadstubs
  ];

  meta = {
    description = "Library for using C++20 coroutines in connection with certain asynchronous Qt actions";
    homepage = "https://github.com/danvratil/qcoro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ smitop ];
    platforms = lib.platforms.linux;
  };
}
