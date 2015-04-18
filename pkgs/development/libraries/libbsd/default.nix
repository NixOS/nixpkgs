{ stdenv, fetchurl }:

let name = "libbsd-0.7.0";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://libbsd.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1fqhbi0vd6xjxazf633x388cc8qyn58l78704s0h6k63wlbhwfqg";
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
