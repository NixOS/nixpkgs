{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pylint
, six
, pytestrunner
}:

buildPythonPackage rec {
  pname = "pytest-pylint";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v6jqxbvzaw6v3xxwd689agy01k0j06q5c3q8gn2f3jlkrvylf4c";
  };

  buildInputs = [ pytestrunner ];

  propagatedBuildInputs = [
    pytest
    pylint
    six
  ];

  # tests not included with release
  doCheck = false;

  meta = with lib; {
    description = "pytest plugin to check source code with pylint";
    homepage = https://github.com/carsongee/pytest-pylint;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
