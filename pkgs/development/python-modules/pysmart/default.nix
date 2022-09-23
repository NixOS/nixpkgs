{ lib
, buildPythonPackage
, fetchFromGitHub
, smartmontools
, humanfriendly
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pysmart";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "py-SMART";
    rev = "v${version}";
    sha256 = "sha256-e46ALiYg0Db/gOzqLmVc1vi9ObhfxzqwfQk9/9pz+r0=";
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
