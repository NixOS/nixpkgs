{ lib
, stdenv
, fetchurl
, lv2
, meson
, ninja
, pkg-config
, python3
, libsndfile
, serd
, sord
, sratom
, gitUpdater

# test derivations
, pipewire
}:

stdenv.mkDerivation rec {
  pname = "lilv";
  version = "0.24.20";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.xz";
    hash = "sha256-T7CCubiyhuqSu7cb3mt1Ykzsq23wzGOe51oqCWIS7rw=";
  };

  nativeBuildInputs = [ meson ninja pkg-config python3 ];
  buildInputs = [ libsndfile serd sord sratom ];
  propagatedBuildInputs = [ lv2 ];

  mesonFlags = [ "-Ddocs=disabled" ];

  passthru = {
    tests = {
      inherit pipewire;
    };
    updateScript = gitUpdater {
      url = "https://gitlab.com/lv2/lilv.git";
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    homepage = "http://drobilla.net/software/lilv";
    description = "A C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
