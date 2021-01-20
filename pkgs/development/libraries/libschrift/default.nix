{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libschrift";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "tomolt";
    repo = pname;
    rev = "c6d20460d6e602e8829d3a227fd7be4c4c3cda86";
    hash = "sha256-BuTmWaWFZ0DXujlbhbmK3Woit8fR9F4DWmKszHX6gOI=";
  };

  postPatch = ''
    substituteInPlace config.mk \
      --replace "PREFIX = /usr/local" "PREFIX = $out"
  '';

  makeFlags = [ "libschrift.a" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/tomolt/libschrift";
    description = "A lightweight TrueType font rendering library";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = [ maintainers.sternenseemann ];
  };
}
