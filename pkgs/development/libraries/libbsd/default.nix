{ stdenv, fetchurl }:

let name = "libbsd-0.8.3";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://libbsd.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1a1l7afchlvvj2zfi7ajcg26bbkh5i98y2v5h9j5p1px9m7n6jwk";
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
