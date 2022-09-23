{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gupnp
}:

stdenv.mkDerivation rec {
  pname = "dleyna-core";
  version = "0.7.0";

  outputs = [ "out" "dev" ];

  setupHook = ./setup-hook.sh;

  src = fetchFromGitHub {
    owner = "phako";
    repo = pname;
    rev = "v${version}";
    sha256 = "i4L9+iyAdBNtgImbD54jkjYL5hvzeZ2OaAyFrcFmuG0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [
    gupnp
  ];

  meta = with lib; {
    description = "Library of utility functions that are used by the higher level dLeyna";
    homepage = "https://github.com/phako/dleyna-core";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21Only;
  };
}
