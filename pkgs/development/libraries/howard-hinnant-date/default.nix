{ stdenv, fetchFromGitHub, cmake, curl, tzdata, fetchpatch, substituteAll }:

stdenv.mkDerivation rec {
  pname = "howard-hinnant-date-unstable";
  version = "2020-03-09";

  src = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "4c1968b8f038483037cadfdbad3215ce21d934bb";
    sha256 = "0dywrf18v1znfnz0gdxgi2ydax466zq34gc1vvg2k7vq17a30wq3";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/HowardHinnant/date/commit/e56b2dce7e89a92e1b9b35caa13b3e938c4cedea.patch";
      sha256 = "0m3qbhq7kmm9qa3jm6d2px7c1dxdj5k9lffgdvqnrwmhxwj1p9n2";
    })
    # Without this patch, this library will drop a `tzdata` directory into
    # `~/Downloads` if it cannot find `/usr/share/zoneinfo`. Make the path it
    # searches for `zoneinfo` be the one from the `tzdata` package.
    (substituteAll {
      src = ./make-zoneinfo-available.diff;
      inherit tzdata;
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ curl ];

  cmakeFlags = [
    "-DBUILD_TZ_LIB=true"
    "-DBUILD_SHARED_LIBS=true"
    "-DUSE_SYSTEM_TZ_DB=true"
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
