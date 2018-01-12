{ lib
, buildPythonPackage
, fetchPypi
, docutils
, readme_renderer
, pygments
, mock
}:

buildPythonPackage rec {
  pname = "restview";
  name = "${pname}-${version}";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f6f1523228eab3269f59dd03ac560f7d370cd81df6fdbcb4914b5e6bd896a11";
  };

  propagatedBuildInputs = [ docutils readme_renderer pygments ];
  checkInputs = [ mock ];

  postPatch = ''
    # dict order breaking tests
    sed -i 's@<a href="http://www.example.com" rel="nofollow">@...@' src/restview/tests.py
  '';

  meta = {
    description = "ReStructuredText viewer";
    homepage = http://mg.pov.lt/restview/;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ koral ];
  };
}