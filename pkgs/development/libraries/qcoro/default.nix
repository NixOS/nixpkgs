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

  meta = with lib; {
    description = "Library for using C++20 coroutines in connection with certain asynchronous Qt actions";
    homepage = "https://github.com/danvratil/qcoro";
    license = licenses.mit;
    maintainers = with maintainers; [ smitop ];
    platforms = platforms.linux;
  };
}
