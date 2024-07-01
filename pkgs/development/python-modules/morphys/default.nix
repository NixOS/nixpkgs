{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
}:
buildPythonPackage rec {
  pname = "morphys";
  version = "1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mkalinski";
    repo = "morphys";
    rev = "0642a71126c32cd26b3a443a5cac27e4e1f7240f";
    sha256 = "1da8s04m5wwih9cvkrks3ymb8v082lia47f274hxmfhi6ma3qc8b";
  };

  pythonImportsCheck = [ "morphys" ];

  meta = with lib; {
    description = "Smart conversions between unicode and bytes types";
    homepage = "https://github.com/mkalinski/morphys";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
