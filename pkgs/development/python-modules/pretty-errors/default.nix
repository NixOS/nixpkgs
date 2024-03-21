{ lib
, buildPythonPackage
, fetchPypi
, colorama
}:

buildPythonPackage rec {
  pname = "pretty-errors";
  version = "1.2.25";

  src = fetchPypi {
    pname = "pretty_errors";
    inherit version;
    hash = "sha256-oWulx1LIfCY7+S+LS1hiTjseKScak5H1ZPErhuk8Z1U=";
  };

  propagatedBuildInputs = [
    colorama
  ];

  doCheck = false;

  meta = with lib; {
    description = "Prettify Python exception output to make it legible";
    homepage = "https://github.com/onelivesleft/PrettyErrors";
    license = licenses.mit;
    maintainers = with maintainers; [ flandweber ];
  };
}
