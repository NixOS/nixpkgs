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
    description = "Pagination support for Flask";
    homepage = "https://github.com/lixxu/flask-paginate";
    changelog = "https://github.com/lixxu/flask-paginate/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
