{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "httpagentparser";
  version = "1.9.5";

  # Github version does not have any release tags
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-U879nWWZD2/lnAN4ytjqG53493DS6L2dh2LtrgM76Ao=";
  };

  # PyPi version does not include test directory
  doCheck = false;

  pythonImportsCheck = [ "httpagentparser" ];

  meta = with lib; {
    homepage = "https://github.com/shon/httpagentparser";
    description = "Extracts OS Browser etc information from http user agent string";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
