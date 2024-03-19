{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libschrift";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "tomolt";
    repo = pname;
    rev = "v" + version;
    sha256 = "01hgvkcb46kr9jzc4ah0js0jy9kr0ll18j2k0c5zil55l3a9rqw1";
  };

  postPatch = ''
    substituteInPlace config.mk \
      --replace "PREFIX = /usr/local" "PREFIX = $out"
  '';

  makeFlags = [ "libschrift.a" ];

  meta = with lib; {
    homepage = "https://github.com/tomolt/libschrift";
    description = "A lightweight TrueType font rendering library";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = [ maintainers.sternenseemann ];
  };
}
