{ stdenv, fetchurl }:

let name = "libbsd-0.8.2";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://libbsd.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "02i5brb2007sxq3mn862mr7yxxm0g6nj172417hjyvjax7549xmj";
  };

  patchPhase = ''
    substituteInPlace Makefile \
      --replace "/usr" "$out" \
      --replace "{exec_prefix}" "{prefix}"
  '';

  meta = {
    description = "Common functions found on BSD systems";
    homepage = http://libbsd.freedesktop.org/;
    license = stdenv.lib.licenses.bsd3;
  };
}
