{ stdenv, fetchFromGitHub
, glm, libxml2, libevdev
, meson, pkg-config, ninja
}:


stdenv.mkDerivation rec {
  pname = "wf-config";
  version = "ec865db3cf932f530adbdd1ea8d1e5b00d25f7a9";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = "wf-config";
    rev = version;
    sha256 = "sha256-JSWdr+Q7kNByKMd6nB3ep/7U87hMSWqgbhYRFGP7Lqw=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];

  buildInputs = [
    glm
    libxml2
    libevdev
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library for managing configuration files, written for wayfire";
    homepage    = "https://wayfire.org/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ishan9299 ];
  };
}
