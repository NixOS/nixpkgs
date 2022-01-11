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
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e50cd802696ea3f5e6ab1bf4c9a90a39c332591d416c99f3d2fa93d7d7ba394";
  };

  nativeBuildInputs = [ pytest-runner ];

  # Replace the dynamic commit hash lookup with the hash from the tag
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'asttokens==' 'asttokens>=' \
      --replace 'subprocess.check_output("git rev-parse HEAD".split())' "' '" \
      --replace 'commithash.decode("utf-8").strip()' "'6e7dba7a8b5f29762d3470da4f44634b819c808d'"
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
