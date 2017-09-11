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
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7842100f3de179c68cfe7c2cf56c61509cd6068bc6dd58ab42c0ade5d5f97ec";
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