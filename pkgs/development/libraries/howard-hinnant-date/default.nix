{ stdenv, fetchFromGitHub, cmake, curl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "howard-hinnant-date-unstable";
  version = "2020-01-24";

  src = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "9a0ee2542848ab8625984fc8cdbfb9b5414c0082";
    sha256 = "0yxsn0hj22n61bjywysxqgfv7hj5xvsl6isma95fl8xrimpny083";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/HowardHinnant/date/commit/e56b2dce7e89a92e1b9b35caa13b3e938c4cedea.patch";
      sha256 = "0m3qbhq7kmm9qa3jm6d2px7c1dxdj5k9lffgdvqnrwmhxwj1p9n2";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ curl ];

  cmakeFlags = [
    "-DBUILD_TZ_LIB=true"
    "-DBUILD_SHARED_LIBS=true"
  ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    description = "A date and time library based on the C++11/14/17 <chrono> header";
    homepage = "https://github.com/HowardHinnant/date";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
