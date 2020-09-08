{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, pkgconfig
, vala
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "elementary-print-shim";
  version = "0.1.3";

  repoName = "print";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-l2IUu9Mj22lZ5yajPcsGrJcJDakNu4srCV0Qea5ybPA=";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [ gtk3 ];

  meta = with stdenv.lib; {
    description = "Simple shim for printing support via Contractor";
    homepage = https://github.com/elementary/print;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
