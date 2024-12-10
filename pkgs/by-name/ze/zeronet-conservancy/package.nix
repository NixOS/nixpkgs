{ lib
, fetchFromGitHub
, python3Packages
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "zeronet-conservancy";
  version = "0.7.10";
  format = "other";

  src = fetchFromGitHub {
    owner = "zeronet-conservancy";
    repo = "zeronet-conservancy";
    rev = "v${version}";
    sha256 = "sha256-ZQYdK0B0z0cXTx7ujFngW3wSa/j8sEuwHB+BC5Xqq8o=";
  };

  propagatedBuildInputs = with python3Packages; [
    gevent msgpack base58 merkletools rsa pysocks pyasn1 websocket-client
    gevent-websocket rencode python-bitcoinlib maxminddb pyopenssl rich defusedxml
    pyaes coincurve
  ];

  buildPhase = ''
    runHook preBuild
    ${python3Packages.python.pythonOnBuildForHost.interpreter} -O -m compileall .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r plugins src *.py $out/share/
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper "$out/share/zeronet.py" "$out/bin/zeronet" \
      --set PYTHONPATH "$PYTHONPATH" \
      --set PATH ${python3Packages.python}/bin
  '';

  passthru.tests = {
    nixos-test = nixosTests.zeronet-conservancy;
  };

  meta = with lib; {
    description = "Fork/continuation of the ZeroNet project";
    mainProgram = "zeronet";
    longDescription = ''
      zeronet-conservancy is a fork/continuation of ZeroNet project (that has
      been abandoned by its creator) that is dedicated to sustaining existing
      p2p network and developing its values of decentralization and freedom,
      while gradually switching to a better designed network.
    '';
    homepage = "https://github.com/zeronet-conservancy/zeronet-conservancy";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fgaz ];
  };
}
