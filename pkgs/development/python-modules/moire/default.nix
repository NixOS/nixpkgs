{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage {
  pname = "moire";
  version = "unstable-2023-08-20";

  src = fetchFromGitHub {
    owner = "enzet";
    repo = "Moire";
    rev = "d4c6635ee9b498c5820ce4af31a231c86a8cd094";
    hash = "sha256-HznIlrY/IBSz6QzEyktwEwYMvNR+psHO4ZLfcgMkl9s=";
  };

  pythonImportsCheck = [ "moire" ];

  meta = with lib; {
    homepage = "https://github.com/enzet/Moire";
    description = "Simple markup language";
    license = licenses.mit;
    maintainers = with maintainers; [ eliandoran ];
  };
}
