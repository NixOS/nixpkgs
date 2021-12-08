{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioprocessing";
  version = "2.0.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
     owner = "dano";
     repo = "aioprocessing";
     rev = "v2.0.0";
     sha256 = "007wfapyydicj9a7pliiacnx0hzfbi21ryn9qzhydf06zsshz2rf";
  };

  # Tests aren't included in pypi package
  doCheck = false;

  pythonImportsCheck = [ "aioprocessing" ];

  meta = {
    description = "A library that integrates the multiprocessing module with asyncio";
    homepage = "https://github.com/dano/aioprocessing";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ uskudnik ];
  };
}
