{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, libpthreadstubs
, qtbase
}:

mkDerivation rec {
  pname = "qcoro";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "danvratil";
    repo = "qcoro";
    rev = "v${version}";
    sha256 = "09543hpy590dndmlxmcm8c58m97blhaii4wbjr655qxdanhhxgzi";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qtbase
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
