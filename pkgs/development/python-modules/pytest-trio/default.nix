{ lib
, buildPythonPackage
, fetchPypi
, trio
, async_generator
, pytest
, isPy27
}:

buildPythonPackage rec {
  pname = "pytest-trio";
  version = "0.5.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a50e9585ebbb0ce9ae83d33bde7865952d76c4d4b8759a0345a551f113d468c";
  };

  propagatedBuildInputs = [
    trio
    async_generator
    pytest
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pytest plugin for trio";
    homepage = https://github.com/python-trio/pytest-trio;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
