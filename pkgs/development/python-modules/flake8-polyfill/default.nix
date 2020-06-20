{ lib, fetchPypi, buildPythonPackage
, flake8
, mock, pep8, pytest }:

buildPythonPackage rec {
  pname = "flake8-polyfill";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nlf1mkqw856vi6782qcglqhaacb23khk9wkcgn55npnjxshhjz4";
  };

  postPatch = ''
    # Failed: [pytest] section in setup.cfg files is no longer supported, change to [tool:pytest] instead.
    substituteInPlace setup.cfg \
      --replace pytest 'tool:pytest'
  '';

  propagatedBuildInputs = [
    flake8
  ];

  checkInputs = [
    mock
    pep8
    pytest
  ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/pycqa/flake8-polyfill";
    description = "Polyfill package for Flake8 plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
