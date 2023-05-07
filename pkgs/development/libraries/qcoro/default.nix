{ stdenv
, gcc12Stdenv
, lib
, fetchFromGitHub
, cmake
, libpthreadstubs
, qtbase
, qtwebsockets
, wrapQtAppsHook
}:

gcc12Stdenv.mkDerivation rec {
  pname = "qcoro";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "danvratil";
    repo = "qcoro";
    rev = "v${version}";
    sha256 = "sha256-kf2W/WAZCpLkq1UIy7iZri4vNaqjGjotB/Xsb+byZV4=";
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
