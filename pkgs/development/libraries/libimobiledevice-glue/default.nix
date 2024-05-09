{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libplist
}:

stdenv.mkDerivation rec {
  pname = "libimobiledevice-glue";
  version = "1.2.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    hash = "sha256-Rfs1i1Tt8uf3WfR+cDlF4L75nFHg9VypjMhHt0TgkyQ=";
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
    maintainers = [ ];
  };
}
