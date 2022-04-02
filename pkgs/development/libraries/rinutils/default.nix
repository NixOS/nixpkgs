{
  stdenv, lib, fetchurl,
  cmake, perl,
}:

stdenv.mkDerivation rec {
  pname = "rinutils";
  version = "0.10.0";

  meta = with lib; {
    homepage = "https://github.com/shlomif/rinutils";
    license = licenses.mit;
  };

  src = fetchurl {
    url = "https://github.com/shlomif/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-cNifCoRk+PSU8zcEt8k5bn/KOS6Kr6pEZXEMGjiemAY=";
  };

  nativeBuildInputs = [ cmake perl ];
}
