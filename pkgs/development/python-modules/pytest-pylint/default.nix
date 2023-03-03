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
  version = "0.19.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2I6DwQI8ZBVIqew1Z3B87udhZjKphq8TNCbUp00GaTI=";
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
