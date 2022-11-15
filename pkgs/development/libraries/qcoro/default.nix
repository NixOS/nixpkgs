{ stdenv
, gcc11Stdenv
, lib
, fetchFromGitHub
, cmake
, libpthreadstubs
, qtbase
, qtwebsockets
, wrapQtAppsHook
}:

gcc11Stdenv.mkDerivation rec {
  pname = "qcoro";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "danvratil";
    repo = "qcoro";
    rev = "v${version}";
    sha256 = "sha256-6kRWBzspwsO0Q6/8gQUr69DJjmkPa3lWrKTmSgVn6V4=";
  };

  outputs = [ "out" "dev" ];

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
