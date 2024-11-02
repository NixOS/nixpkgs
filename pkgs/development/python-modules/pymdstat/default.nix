{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
}:

buildPythonPackage rec {
  pname = "pymdstat";
  version = "0.4.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ifQZXc+it/UTltHc1ZL2zxJu7GvAxYzzmB4D+mCqEoE=";
  };

  checkPhase = ''
    ${python.interpreter} $src/unitest.py
  '';

  pythonImportsCheck = [ "pymdstat" ];

  meta = with lib; {
    description = "Pythonic library to parse Linux /proc/mdstat file";
    homepage = "https://github.com/nicolargo/pymdstat";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.mit;
  };
}
