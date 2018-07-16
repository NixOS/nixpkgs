{ stdenv, lib, buildPythonPackage, fetchFromGitHub, openssl }:

let ext = if stdenv.isDarwin then "dylib" else "so";
in buildPythonPackage rec {
  pname = "bitcoinlib";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner  = "petertodd";
    rev    = "7a8a47ec6b722339de1d0a8144e55b400216f90f";
    repo   = "python-bitcoinlib";
    sha256 = "1s1jm2nid7ab7yiwlp1n2v3was9i4q76xmm07wvzpd2zvn5zb91z";
  };

  postPatch = ''
    substituteInPlace bitcoin/core/key.py --replace \
      "ctypes.util.find_library('ssl') or 'libeay32'" \
      "'${openssl.out}/lib/libssl.${ext}'"
  '';

  meta = {
    homepage = src.meta.homepage;
    description = "Easy interface to the Bitcoin data structures and protocol";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ jb55 ];
  };
}
