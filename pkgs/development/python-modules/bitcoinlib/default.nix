{ stdenv, lib, buildPythonPackage, isPy3k, fetchFromGitHub, openssl }:

buildPythonPackage rec {
  pname = "bitcoinlib";
  version = "0.11.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "petertodd";
    repo = "python-bitcoinlib";
    rev = "refs/tags/python-bitcoinlib-v${version}";
    sha256 = "sha256-/VgCTN010W/Svdrs0mGA8W1YZnyTHhcaWJKgP/c8CN8=";
  };

  postPatch = ''
    substituteInPlace bitcoin/core/key.py --replace \
      "ctypes.util.find_library('ssl.35') or ctypes.util.find_library('ssl') or 'libeay32'" \
      "'${lib.getLib openssl}/lib/libssl${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  pythonImportsCheck = [ "bitcoin" "bitcoin.core.key" ];

  meta = with lib; {
    homepage = "https://github.com/petertodd/python-bitcoinlib";
    description = "Easy interface to the Bitcoin data structures and protocol";
    changelog = "https://github.com/petertodd/python-bitcoinlib/raw/${src.rev}/release-notes.md";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ jb55 ];
  };
}
