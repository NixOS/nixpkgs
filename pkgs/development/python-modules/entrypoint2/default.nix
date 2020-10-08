{ lib, buildPythonPackage, fetchPypi, EasyProcess, pathpy, pytest }:

buildPythonPackage rec {
  pname = "entrypoint2";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15dya04884armqjdyqz1jgachkqgh9dc3p25lvyz9afvg73k2qav";
  };

  propagatedBuildInputs = [ ];

  pythonImportsCheck = [ "entrypoint2" ];

  # argparse is part of the standardlib
  prePatch = ''
    substituteInPlace setup.py --replace "argparse" ""
  '';

  checkInputs = [ EasyProcess pathpy pytest ];

  # 0.2.1 has incompatible pycache files included
  # https://github.com/ponty/entrypoint2/issues/8
  checkPhase = ''
    rm -rf tests/__pycache__
    pytest tests
  '';

  meta = with lib; {
    description = "Easy to use command-line interface for python modules";
    homepage = "https://github.com/ponty/entrypoint2/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ austinbutler ];
  };
}
