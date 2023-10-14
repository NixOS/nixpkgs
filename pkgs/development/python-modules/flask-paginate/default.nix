{ lib
, buildPythonPackage
, fetchPypi
, flask
, pythonOlder
}:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "2023.10.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P6Q/Q6+kUzby+wXPjO7TqjeL9LydqbNgceu2juWeEpM=";
  };

  propagatedBuildInputs = [
    flask
  ];

  meta = with lib; {
    description = "Pagination support for Flask";
    homepage = "https://github.com/lixxu/flask-paginate";
    changelog = "https://github.com/lixxu/flask-paginate/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
