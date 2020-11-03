{ stdenv
, buildPythonPackage
, fetchPypi
, polib
, pymd4c
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdpo";
  version = "0.3.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d5w759k0a8kfyclxdvfihlbmk19vp81w1mh9fc3nx13wcc64581";
  };

  propagatedBuildInputs = [ polib pymd4c ];

  # package does not contain any tests
  doCheck = false;
  pythonImportsCheck = [ "mdpo" ];

  meta = with stdenv.lib; {
    description = "Markdown file translation utilities using pofiles";
    homepage = "https://github.com/mondeja/mdpo";
    license = licenses.bsd3;
    maintainers = with maintainers; [ euandreh ];
  };
}
