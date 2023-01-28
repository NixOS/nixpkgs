{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libplist
}:

stdenv.mkDerivation rec {
  pname = "libimobiledevice-glue";
  version = "0.pre+date=2022-05-22";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "d2ff7969dcd0a12e4f18f63dab03e6cd03054fcb";
    hash = "sha256-BAdpJK6/iUKCNYLaCJQo0VK63AdIafO8wGbNhnvEc/o=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libplist
  ];

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
    description = "Library with common code used by the libraries and tools around the libimobiledevice project.";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinisil ];
  };
}
