{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "python-reprshed";
  version = "1.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mentalisttraceur";
    repo = "python-reprshed";
    rev = "v${version}";
    hash = "sha256-XfmiewI74eDLKTAU6Ed76QXfJYMRb+idRACl6CW07ME=";
  };

  pythonImportsCheck = [ "reprshed" ];

  meta = with lib; {
    homepage = "https://github.com/mentalisttraceur/python-reprshed";
    description = "Toolshed for writing great __repr__ methods quickly and easily";
    license = licenses.bsd0;
    maintainers = with maintainers; [ netali ];
  };
}
