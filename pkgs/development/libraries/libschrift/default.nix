{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libschrift";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "tomolt";
    repo = pname;
    rev = "v" + version;
    sha256 = "0fvji0z6z2al68p07w58l4hc29ds68v71h7z84vxiqhxnsgc0hlv";
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
