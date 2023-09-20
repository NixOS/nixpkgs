{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libplist
}:

stdenv.mkDerivation rec {
  pname = "libimobiledevice-glue";
  version = "1.0.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    hash = "sha256-9TjIYz6w61JaJgOJtWteIDk9bO3NnXp/2ZJwdirFcYM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libplist
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
    description = "Library with common code used by the libraries and tools around the libimobiledevice project";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinisil ];
  };
}
