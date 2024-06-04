{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
}:

buildPythonPackage rec {
  pname = "pymdstat";
  version = "0.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = pname;
    rev = "v${version}";
    sha256 = "01hj8vyd9f7610sqvzphpr033rvnazbwvl11gi18ia3yqlnlncp0";
  };

  checkPhase = ''
    ${python.interpreter} $src/unitest.py
  '';

  pythonImportsCheck = [ "pymdstat" ];

  meta = with lib; {
    description = "A pythonic library to parse Linux /proc/mdstat file";
    homepage = "https://github.com/nicolargo/pymdstat";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.mit;
  };
}
