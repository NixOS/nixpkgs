{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "attr";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HO68p2gYHNzOmCdhGx1yjlkr5dKTkRU56j0LC/oRRvQ=";
  };

  pythonImportsCheck = [
    "attr"
  ];

  meta = with lib; {
    description = "Simple decorator to set attributes of target function or class in a DRY way";
    homepage = "https://github.com/denis-ryzhkov/attr";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
