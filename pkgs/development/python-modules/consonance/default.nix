{ buildPythonPackage, lib, fetchFromGitHub, pytest, dissononce, python-axolotl-curve25519
, transitions, protobuf, nose, isPy27
}:

buildPythonPackage rec {
  pname = "consonance";
  version = "0.1.3";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "consonance";
    rev = version;
    sha256 = "1ifs0fq6i41rdna1kszv5sf87qbqx1mn98ffyx4xhw4i9r2grrjv";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    # skipping online test as it requires network with uplink
    nosetests tests/test_handshakes_offline.py
  '';

  propagatedBuildInputs = [ dissononce python-axolotl-curve25519 transitions protobuf ];

  meta = with lib; {
    homepage = "https://pypi.org/project/consonance/";
    license = licenses.gpl3;
    description = "WhatsApp's handshake implementation using Noise Protocol";
  };
}
