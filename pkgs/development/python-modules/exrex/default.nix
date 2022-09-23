{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "exrex";
  version = "0.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wq8nyycdprxl9q9y1pfhkbca4rvysj45h1xn7waybl3v67v3f1z";
  };

  # Projec thas no released tests
  doCheck = false;
  pythonImportsCheck = [ "exrex" ];

  meta = with lib; {
    description = "Irregular methods on regular expressions";
    homepage = "https://github.com/asciimoo/exrex";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
