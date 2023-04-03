{ lib
, stdenv
, fetchFromGitHub
, pololu-tic
, cmake
, pkg-config
, indilib
}:

stdenv.mkDerivation rec {
  pname = "ticfocuser-ng";
  version = "1.0-rc";

  src = fetchFromGitHub {
    owner = "sebo-b";
    repo = "TicFocuser-ng";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-rt9KkZ7idRTwsnJp1JYjkBuAw4P6BIz3jna/mKRhpjQ=";
  };

  patches = [ ./driver_xml.patch ];

  nativeBuildInputs = [ cmake pkg-config ];
  propagatedBuildInputs = [ pololu-tic ];
  buildInputs = [ indilib ];

  cmakeFlags = [
  ];

  postPatch = ''
    export cmakeFlags="$cmakeFlags
      -DINDI_DATA_DIR=$out/share/indi/
    "
  '';

  meta = with lib; {
    homepage = "https://github.com/sebo-b/TicFocuser-ng";
    description = "INDI Driver for USB focuser based on Pololu Tic controller";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bzizou ];
  };
}
