{ stdenv, fetchFromGitHub
, cmake, cmake-extras
}:

stdenv.mkDerivation rec {
  pname = "deviceinfo-unstable";
  version = "2020-09-04";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "deviceinfo";
    rev = "a830f334a7cfe97723a2ba2811771ce39d381398";
    sha256 = "19s9k7lwnhzbq24sm9nklxfpr4js2sh6rz1sjk57iqz7r1d1j1vq";
  };

  nativeBuildInputs = [ cmake cmake-extras ];

  meta = with stdenv.lib; {
    description = "Library to detect and configure devices";
    homepage = "https://github.com/ubports/deviceinfo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
