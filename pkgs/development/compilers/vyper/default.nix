{ lib, buildPythonPackage, fetchPypi, writeText, asttokens
, pycryptodome, pytest_xdist, pytestcov, recommonmark, semantic-version, sphinx
, sphinx_rtd_theme, pytestrunner }:

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
  version = "0.2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "474e0225bbfde86df0d16cb1203610c9dc7b950d5a2984121ff42b8f342628e3";
  };

  nativeBuildInputs = [ pytestrunner ];

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
