{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "zeronet";
  version = "0.7.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "HelloZeroNet";
    repo = "ZeroNet";
    rev = "v${version}";
    sha256 = "04prgicm0yjh2klcxdgwx1mvlsxxi2bdkzfcvysvixbgq20wjvdk";
  };

  propagatedBuildInputs = with python3Packages; [
    gevent
    msgpack
    base58
    merkletools
    rsa
    pysocks
    pyasn1
    websocket-client
    gevent-websocket
    rencode
    python-bitcoinlib
    maxminddb
    pyopenssl
  ];

  buildPhase = ''
    ${python3Packages.python.pythonOnBuildForHost.interpreter} -O -m compileall .
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r plugins src tools *.py $out/share/
  '';

  postFixup = ''
    makeWrapper "$out/share/zeronet.py" "$out/bin/zeronet" \
      --set PYTHONPATH "$PYTHONPATH" \
      --set PATH ${python3Packages.python}/bin
  '';

  meta = {
    description = "Decentralized websites using Bitcoin crypto and BitTorrent network";
    homepage = "https://zeronet.io/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ fgaz ];
    knownVulnerabilities = [
      ''
        Unmaintained. Probable XSS/code injection vulnerability.
        Switching to the maintained zeronet-conservancy package is recommended
      ''
    ];
  };
}
