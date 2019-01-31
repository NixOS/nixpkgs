{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "filetype";
  version = "1.0.2";

  # No tests in PyPI tarball
  # See https://github.com/h2non/filetype.py/pull/33
  src = fetchFromGitHub {
    owner = "h2non";
    repo = "filetype.py";
    rev = "v${version}";
    sha256 = "000gl3q2cadfnmqnbxg31ppc3ak8blzb4nfn75faxbp7b6r5qgr2";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Infer file type and MIME type of any file/buffer";
    homepage = https://github.com/h2non/filetype.py;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
