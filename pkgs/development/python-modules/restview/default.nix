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
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45320b4e52945d23b3f1aeacc7ff97a3b798204fe625f8b81ed5322326d5bcd1";
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