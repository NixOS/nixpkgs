{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, requests, iso8601, bottle, pytestCheckHook }:

buildPythonPackage rec {
  pname = "m3u8";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "globocom";
    repo = pname;
    rev = version;
    hash = "sha256-EfHhmV2otEgEy2OVohS+DF7dk97GFdWZ4cFCERZBmlA=";
  };

  patches = [
    # Fix hardcoded /tmp dir (fix build on Hydra)
    (fetchpatch {
      url = "https://github.com/globocom/m3u8/commit/cf7ae5fda4681efcea796cd7c51c02f152c36009.patch";
      hash = "sha256-SEETpIJQddid8D//6DVrSGs/BqDeMOzufE0bBrm+/xY=";
    })
  ];

  propagatedBuildInputs = [ requests iso8601 ];

  nativeCheckInputs = [ bottle pytestCheckHook ];

  pytestFlagsArray = [
    "tests/test_parser.py"
    "tests/test_model.py"
    "tests/test_variant_m3u8.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/globocom/m3u8";
    description = "Python m3u8 parser";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}

