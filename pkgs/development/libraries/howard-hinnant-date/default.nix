{ lib, stdenv, fetchFromGitHub, cmake, tzdata, fetchpatch, substituteAll }:

stdenv.mkDerivation rec {
  pname = "howard-hinnant-date";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "v${version}";
    sha256 = "1qk7pgnk0bpinja28104qha6f7r1xwh5dy3gra7vjkqwl0jdwa35";
  };

  patches = [
    # Add pkg-config file
    # https://github.com/HowardHinnant/date/pull/538
    (fetchpatch {
      name = "output-date-pc-for-pkg-config.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/date/538-output-date-pc-for-pkg-config.patch?id=11f6b4d4206b0648182e7b41cd57dcc9ccea0728";
      sha256 = "1ma0586jsd89jgwbmd2qlvlc8pshs1pc4zk5drgxi3qvp8ai1154";
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

  cmakeFlags = [
    "-DBUILD_TZ_LIB=true"
    "-DBUILD_SHARED_LIBS=true"
    "-DUSE_SYSTEM_TZ_DB=true"
  ];

  outputs = [ "out" "dev" ];

  meta = with lib; {
    license = licenses.mit;
    description = "A date and time library based on the C++11/14/17 <chrono> header";
    homepage = "https://github.com/HowardHinnant/date";
    platforms = platforms.linux;
    maintainers = with maintainers; [ r-burns ];
  };
}
