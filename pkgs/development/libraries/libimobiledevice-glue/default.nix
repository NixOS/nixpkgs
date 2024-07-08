{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libplist
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "libimobiledevice-glue";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    hash = "sha256-+poCrn2YHeH8RQCfWDdnlmJB4Nf+unWUVwn7YwILHIs=";
  };

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libplist
  ];

  outputs = [ "out" "dev" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
    description = "Library with common code used by the libraries and tools around the libimobiledevice project";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
