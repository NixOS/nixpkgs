{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pylint
, six
, pytest-runner
, toml
}:

buildPythonPackage rec {
  pname = "pytest-pylint";
  version = "0.18.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "790c7a8019fab08e59bd3812db1657a01995a975af8b1c6ce95b9aa39d61da27";
  };

  nativeBuildInputs = [ pytest-runner ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    pylint
    six
    toml
  ];

  # tests not included with release
  doCheck = false;

  meta = with lib; {
    description = "pytest plugin to check source code with pylint";
    homepage = "https://github.com/carsongee/pytest-pylint";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
