{
  stdenv,
  lib,
  buildPythonPackage,
  isPy3k,
  fetchFromGitHub,
  openssl,
}:

buildPythonPackage rec {
  pname = "python-bitcoinlib";
  version = "0.12.2";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "petertodd";
    repo = "python-bitcoinlib";
    rev = "refs/tags/python-bitcoinlib-v${version}";
    hash = "sha256-jfd2Buy6GSCH0ZeccRREC1NmlS6Mq1qtNv/NLNJOsX0=";
  };

  postPatch = ''
    substituteInPlace bitcoin/core/key.py --replace \
      "ctypes.util.find_library('ssl.35') or ctypes.util.find_library('ssl') or ctypes.util.find_library('libeay32')" \
      "'${lib.getLib openssl}/lib/libssl${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  pythonImportsCheck = [
    "bitcoin"
    "bitcoin.core.key"
  ];

  meta = with lib; {
    homepage = "https://github.com/petertodd/python-bitcoinlib";
    description = "Easy interface to the Bitcoin data structures and protocol";
    changelog = "https://github.com/petertodd/python-bitcoinlib/raw/${src.rev}/release-notes.md";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ jb55 ];
  };
}
