{ lib, buildPythonPackage, fetchPypi, writeText, asttokens
, pycryptodome, pytest-xdist, pytest-cov, recommonmark, semantic-version, sphinx
, sphinx_rtd_theme, pytest-runner }:

let
  sample-contract = writeText "example.vy" ''
    count: int128

    @external
    def __init__(foo: address):
        self.count = 1
  '';
in

buildPythonPackage rec {
  pname = "vyper";
  version = "0.2.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e763561a161c35c03b92a0c176096dd9b4c78ab003c2f08324d443f459b3de84";
  };

  nativeBuildInputs = [ pytest-runner ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'asttokens==' 'asttokens>=' \
      --replace 'subprocess.check_output("git rev-parse HEAD".split())' "' '" \
      --replace 'commithash.decode("utf-8").strip()' "'069936fa3fee8646ff362145593128d7ef07da38'"
  '';

  propagatedBuildInputs = [
    asttokens
    pycryptodome
    semantic-version

    # docs
    recommonmark
    sphinx
    sphinx_rtd_theme
  ];

  checkPhase = ''
    $out/bin/vyper "${sample-contract}"
  '';

  meta = with lib; {
    description = "Pythonic Smart Contract Language for the EVM";
    homepage = "https://github.com/vyperlang/vyper";
    license = licenses.asl20;
    maintainers = with maintainers; [ siraben ];
  };
}
