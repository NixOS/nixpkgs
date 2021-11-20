{ lib, buildPythonPackage, fetchFromGitHub, requests, iso8601, bottle, pytestCheckHook }:

buildPythonPackage rec {
  pname = "m3u8";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "globocom";
    repo = pname;
    rev = version;
    sha256 = "sha256-EfHhmV2otEgEy2OVohS+DF7dk97GFdWZ4cFCERZBmlA=";
  };

  propagatedBuildInputs = [ requests iso8601 ];

  checkInputs = [ bottle pytestCheckHook ];

  pytestFlagsArray = [
    "tests/test_parser.py"
    "tests/test_model.py"
    "tests/test_variant_m3u8.py"
  ];

  preCheck = ''
    # Fix test on Hydra
    substituteInPlace tests/test_model.py --replace "/tmp/d.m3u8" "$TMPDIR/d.m3u8"
  '';

  meta = with lib; {
    homepage = "https://github.com/globocom/m3u8";
    description = "Python m3u8 parser";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}

