{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, libite
, libuev
, libconfuse
}:
stdenv.mkDerivation rec {
  pname = "watchdogd";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "watchdogd";
    rev = version;
    hash = "sha256-JNJj0CJGJXuIRpob2RXYqDRrU4Cn20PRxOjQ6TFsVYQ=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ libite libuev libconfuse ];

  meta = with lib; {
    description = "Advanced system & process supervisor for Linux";
    homepage = "https://troglobit.com/watchdogd.html";
    changelog = "https://github.com/troglobit/watchdogd/releases/tag/${version}";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vifino ];
  };
}
