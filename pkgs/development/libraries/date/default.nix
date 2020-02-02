{ stdenv
, fetchFromGitHub
, cmake
, curl
}: stdenv.mkDerivation rec {
  pname = "date";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "v${version}";
    sha256 = "1761y28zc6a5adnp09pkjjgir2i0b065gdy0jwwqwi0q3g1zp0h5";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ curl ];

  cmakeFlags = [
    "-DBUILD_TZ_LIB=true"
    "-DBUILD_SHARED_LIBS=true"
  ];

  meta = with stdenv.lib; {
    description = "A date and time library based on the C++11/14/17 <chrono> header";
    homepage = "https://github.com/HowardHinnant/date";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.unix;
  };
}
