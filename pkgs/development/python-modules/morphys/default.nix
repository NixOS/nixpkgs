{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
}:
buildPythonPackage {
  pname = "morphys";
  version = "1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mkalinski";
    repo = "morphys";
    rev = "0642a71126c32cd26b3a443a5cac27e4e1f7240f";
    hash = "sha256-CzE8VDURutohOcIdoiIVCGy0qh965rlZgpHzUgnQSLU=";
  };

  pythonImportsCheck = [ "morphys" ];

  meta = {
    description = "Smart conversions between unicode and bytes types";
    homepage = "https://github.com/mkalinski/morphys";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
}
