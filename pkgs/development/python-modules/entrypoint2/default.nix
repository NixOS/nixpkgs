{ lib, buildPythonPackage, fetchPypi, EasyProcess, pathpy, pytest }:

buildPythonPackage rec {
  pname = "entrypoint2";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "67e906f6ad958d83f48b4edec28d7dd82670e9261988f6b4a6b63abc9fb3be56";
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
