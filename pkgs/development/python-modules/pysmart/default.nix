{ lib
, buildPythonPackage
, fetchFromGitHub
, smartmontools
, humanfriendly
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pysmart";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "py-SMART";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-slLk4zoW0ht9hiOxyBt0caekjrPgih9G99pRiD2vIxE=";
  };

  postPatch = ''
    substituteInPlace pySMART/utils.py \
      --replace "which('smartctl')" '"${smartmontools}/bin/smartctl"'
  '';

  propagatedBuildInputs = [ humanfriendly ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pySMART" ];

  meta = with lib; {
    description = "Wrapper for smartctl (smartmontools)";
    homepage = "https://github.com/truenas/py-SMART";
    maintainers = with maintainers; [ nyanloutre ];
    license = licenses.lgpl21Only;
  };
}
