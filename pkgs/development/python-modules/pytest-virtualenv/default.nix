{ lib, buildPythonPackage, fetchPypi
, pytest, pytest-cov, mock, cmdline, pytest-fixture-config, pytest-shutil, virtualenv }:

buildPythonPackage rec {
  pname = "pytest-virtualenv";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03w2zz3crblj1p6i8nq17946hbn3zqp9z7cfnifw47hi4a4fww12";
  };

  nativeCheckInputs = [ pytest pytest-cov mock cmdline ];
  propagatedBuildInputs = [ pytest-fixture-config pytest-shutil virtualenv ];
  checkPhase = "py.test tests/unit ";

  nativeBuildInputs = [ pytest ];

  meta = with lib; {
    description = "Create a Python virtual environment in your test that cleans up on teardown. The fixture has utility methods to install packages and list what’s installed.";
    homepage = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ ryansydnor ];
  };
}
