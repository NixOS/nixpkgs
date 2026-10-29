{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "hlk-sw16";
  version = "0.0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jameshilliard";
    repo = "hlk-sw16";
    rev = version;
    hash = "sha256-vyH4Vkc3XXP2GAo7f8UOsJ2kxHlPte1RTMh2k21BGgQ=";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "hlk_sw16" ];

  meta = {
    description = "Python client for HLK-SW16";
    homepage = "https://github.com/jameshilliard/hlk-sw16";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
