{ lib
, buildPythonPackage
, fetchPypi
, markdown
}:

buildPythonPackage rec {
  pname = "pymdown-extensions";
  version = "8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x560b57mabn534vylzbnxx970nfwh0iz2scqvwi04wymm5aknmn";
  };


  propagatedBuildInputs = [
    markdown
  ];

  # test fails due to missing deps
  doCheck = false;

  pythonImportsCheck = [ "pymdownx" ];


  meta = with lib; {
    description = "Extensions for Python Markdown";
    homepage = "https://facelessuser.github.io/pymdown-extensions/";
    license = licenses.mit;
    maintainers = with maintainers; [ lde ];
  };
}
