{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, lxml
, six
}:
buildPythonPackage rec {
  pname = "ebooklib";
  version = "0.17.1";

  src = fetchPypi {
    inherit version;
    pname = "EbookLib";
    sha256 = "sha256-/iPiLCgFAZbGjbPnsTsle/OUJtknyzlcbyzBOsETJ/E=";
  };

  propagatedBuildInputs = [ lxml six ];

  pythonImportsCheck = [ "ebooklib" ];

  meta = with lib; {
    description = "A library for handling EPUB and Kindle files";
    homepage = "https://github.com/aerkalov/ebooklib";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
