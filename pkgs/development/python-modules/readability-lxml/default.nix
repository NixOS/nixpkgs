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

  checkInputs = [
    pytestCheckHook
    timeout-decorator
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Fast python port of arc90's readability tool";
    homepage = "https://github.com/buriy/python-readability";
    license = licenses.apsl20;
    maintainers = with maintainers; [ siraben ];
  };
}
