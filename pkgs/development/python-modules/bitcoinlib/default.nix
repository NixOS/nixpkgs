{ stdenv, lib, buildPythonPackage, isPy3k, fetchFromGitHub, openssl }:

let ext = if stdenv.isDarwin then "dylib" else "so";
in buildPythonPackage rec {
  pname = "bitcoinlib";
  version = "0.11.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner  = "petertodd";
    repo   = "python-bitcoinlib";
    rev    = "python-${pname}-v${version}";
    sha256 = "0pwypd966zzivb37fvg4l6yr7ihplqnr1jwz9zm3biip7x89bdzm";
  };

  postPatch = ''
    substituteInPlace bitcoin/core/key.py --replace \
      "ctypes.util.find_library('ssl') or 'libeay32'" \
      "'${lib.getLib openssl}/lib/libssl.${ext}'"
  '';

  meta = {
    homepage = src.meta.homepage;
    description = "Easy interface to the Bitcoin data structures and protocol";
    license = with lib.licenses; [ lgpl3 ];
    maintainers = with lib.maintainers; [ jb55 ];
  };
}
