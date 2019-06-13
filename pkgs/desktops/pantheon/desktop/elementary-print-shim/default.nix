{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig, vala, gtk3 }:

stdenv.mkDerivation rec {
  pname = "print";
  version = "0.1.3";

  name = "elementary-print-shim-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1w3cfap7j42x14mqpfqdm46hk5xc0v5kv8r6wxcnknr3sfxi8qlp";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}-shim";
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
