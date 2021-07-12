{
  stdenv, lib, fetchurl,
  cmake, perl,
}:

stdenv.mkDerivation rec {
  pname = "rinutils";
  version = "0.8.0";

  meta = with lib; {
    homepage = "https://github.com/shlomif/rinutils";
    license = licenses.mit;
  };

  src = fetchurl {
    url = "https://github.com/shlomif/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "1q09aihm5m42xiq2prpa9mf0srwiirzgzblkp5nl74i7zg6pg5hx";
  };

  nativeBuildInputs = [ cmake perl ];
}
