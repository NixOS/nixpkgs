{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, chardet
, cssselect
, lxml
}:

buildPythonPackage rec {
  pname = "readability-lxml";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5R/qVrWQmq+IbTB9SOeeCWKTJVr6Vnt9CLypTSWxpOE=";
  };

  propagatedBuildInputs = [ chardet cssselect lxml ];

  postPatch = ''
    substituteInPlace setup.py --replace 'sys.platform == "darwin"' "False"
  '';

  doCheck = false;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Fast python port of arc90's readability tool";
    homepage = "https://github.com/buriy/python-readability";
    license = licenses.apsl20;
    maintainers = with maintainers; [ siraben ];
  };
}
