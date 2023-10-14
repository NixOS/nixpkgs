{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "2023.10.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-P6Q/Q6+kUzby+wXPjO7TqjeL9LydqbNgceu2juWeEpM=";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = "https://github.com/lixxu/flask-paginate";
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
