{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pylint
, six
, pytestrunner
, toml
}:

buildPythonPackage rec {
  pname = "pytest-pylint";
  version = "0.17.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0c177d63f6e3f5b82fa2720a6570dd2ecff1616c26ed6d02d0cbf75fd98ddf9";
  };

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [
    pytest
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
