{ lib, buildPythonPackage, fetchPypi
, cryptography
, invoke
, mock
, paramiko
, pytest
, pytest-relaxed
}:

buildPythonPackage rec {
  pname = "fabric";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47f184b070272796fd2f9f0436799e18f2ccba4ee8ee587796fca192acd46cd2";
  };

  # only relevant to python < 3.4
  postPatch = ''
    substituteInPlace setup.py \
        --replace ', "pathlib2"' ' '
  '';

  propagatedBuildInputs = [ invoke paramiko cryptography ];
  checkInputs = [ pytest mock pytest-relaxed ];

  # requires pytest_relaxed, which doesnt have official support for pytest>=5
  # https://github.com/bitprophet/pytest-relaxed/issues/12
  doCheck = false;
  checkPhase = ''
    pytest tests
  '';
  pythonImportsCheck = [ "fabric" ];

  meta = with lib; {
    description = "Pythonic remote execution";
    homepage    = "https://www.fabfile.org/";
    license     = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
