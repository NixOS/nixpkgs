{ stdenv
, lib
, fetchFromGitHub
, cmake
, gcc11
, libpthreadstubs
, qtbase
, qtwebsockets
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
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
    gcc11
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
