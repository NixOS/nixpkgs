{ lib, buildPythonPackage, fetchFromGitHub, EasyProcess, pathpy, pytest }:

buildPythonPackage rec {
  pname = "entrypoint2";
  version = "0.2.4";

  src = fetchFromGitHub {
     owner = "ponty";
     repo = "entrypoint2";
     rev = "0.2.4";
     sha256 = "0vbiv9l509rsi94rbhcjz56d71bgy9nq8xmjzd1f4q0iblkvg5pi";
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
