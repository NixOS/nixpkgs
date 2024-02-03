{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, chardet
, cssselect
, lxml
, timeout-decorator
}:

buildPythonPackage rec {
  pname = "readability-lxml";
  version = "0.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "buriy";
    repo = "python-readability";
    rev = "v${version}";
    hash = "sha256-MKdQRety24qOG9xgIdaCJ72XEImP42SlMG6tC7bwzo4=";
  };

  propagatedBuildInputs = [ chardet cssselect lxml ];

  postPatch = ''
    substituteInPlace setup.py --replace 'sys.platform == "darwin"' "False"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    timeout-decorator
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Test is broken on darwin. Fix in master from https://github.com/buriy/python-readability/pull/178
    "test_many_repeated_spaces"
  ];

  meta = with lib; {
    description = "Fast python port of arc90's readability tool";
    homepage = "https://github.com/buriy/python-readability";
    license = licenses.asl20;
    maintainers = with maintainers; [ siraben ];
  };
}
