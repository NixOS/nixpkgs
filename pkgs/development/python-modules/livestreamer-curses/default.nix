{ stdenv
, buildPythonPackage
, fetchurl
, isPyPy
, livestreamer
}:

buildPythonPackage rec {
  version = "1.5.2";
  pname = "livestreamer-curses";
  disabled = isPyPy;

  src = fetchurl {
    url = "https://github.com/gapato/livestreamer-curses/archive/v${version}.tar.gz";
    sha256 = "1v49sym6mrci9dxy0a7cpbp4bv6fg2ijj6rwk4wzg18c2x4qzkhn";
  };

  propagatedBuildInputs = [ livestreamer ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/gapato/livestreamer-curses";
    description = "Curses frontend for livestreamer";
    license = licenses.mit;
  };

}
