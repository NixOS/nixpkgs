{ stdenv, buildPythonPackage, fetchPypi, requests, six, mock, httmock }:

buildPythonPackage rec {
  pname   = "python-gitlab";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "125zimbdprfx2j90dp19hyh60lzj11264bm494awc585pr6v9d3k";
  };

  propagatedBuildInputs = [ requests six ];

  checkInputs = [ mock httmock ];

  meta = with stdenv.lib; {
    description = "Interact with GitLab API";
    homepage    = https://github.com/python-gitlab/python-gitlab;
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
