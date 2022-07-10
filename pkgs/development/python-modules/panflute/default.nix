{ lib
, fetchPypi
, click
, pyyaml
, buildPythonPackage
, isPy3k
}:

buildPythonPackage rec{
  version = "2.1.5";
  pname = "panflute";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7xHcWVoZh51PlonvmoOCBKJGNMpjT7z8jkoO1B65EqE=";
  };

  propagatedBuildInputs = [
    click
    pyyaml
  ];

  meta = with lib; {
    description = "A Pythonic alternative to John MacFarlane's pandocfilters, with extra helper functions";
    homepage = "http://scorreia.com/software/panflute";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
