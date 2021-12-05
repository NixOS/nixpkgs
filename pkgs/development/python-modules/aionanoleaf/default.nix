{ lib, aiohttp, buildPythonPackage, fetchFromGitHub, pythonOlder }:

buildPythonPackage rec {
  pname = "aionanoleaf";
  version = "0.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ys6zFfS0R3L504fkMVZvt1IjCzLoT1OEW/OOCaXp7dw=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aionanoleaf" ];

  meta = with lib; {
    description = "Python wrapper for the Nanoleaf API";
    homepage = "https://github.com/milanmeu/aionanoleaf";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
