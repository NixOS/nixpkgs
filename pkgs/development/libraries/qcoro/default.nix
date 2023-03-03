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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "danvratil";
    repo = "qcoro";
    rev = "v${version}";
    sha256 = "cHd2CwzP4oD/gy9qsDWIMgvlfBQq1p9C4G7JNAs4XW4=";
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
