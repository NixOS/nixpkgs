{ stdenv, fetchurl }:

let name = "libbsd-0.3.0";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://libbsd.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "fbf36ed40443e1d0d795adbae8d461952509e610c3ccf0866ae160b723f7fe38";
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
