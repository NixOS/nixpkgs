{ stdenv, lib, buildPythonPackage, isPy3k, fetchFromGitHub, openssl }:

buildPythonPackage rec {
  pname = "bitcoinlib";
  version = "0.11.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner  = "petertodd";
    repo   = "python-bitcoinlib";
    rev = "refs/tags/python-bitcoinlib-v${version}";
    sha256 = "sha256-/VgCTN010W/Svdrs0mGA8W1YZnyTHhcaWJKgP/c8CN8=";
  };

  postPatch = ''
    substituteInPlace bitcoin/core/key.py --replace \
      "ctypes.util.find_library('ssl') or 'libeay32'" \
      "'${lib.getLib openssl}/lib/libssl${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  meta = {
    homepage = src.meta.homepage;
    description = "Easy interface to the Bitcoin data structures and protocol";
    license = with lib.licenses; [ lgpl3 ];
    maintainers = with lib.maintainers; [ jb55 ];
  };
}
