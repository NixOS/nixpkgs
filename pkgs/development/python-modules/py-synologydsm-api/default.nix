{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, poetry-core
, urllib3
, requests
}:

buildPythonPackage rec {
  pname = "py-synologydsm-api";
  version = "1.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "synologydsm-api";
    rev = "v${version}";
    sha256 = "sha256-UQdPwvRdv7SCOTxkA1bfskQ9oL/DB0j1TdJE04ODyj8=";
  };

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [ urllib3 requests ];
  pythonImportsCheck = [ "synology_dsm" ];
  checkInputs = [ pytestCheckHook ];

  postPatch = ''
    # was fixed upstream but not released, remove after upgrade to version > 1.0.2
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  meta = with lib; {
    description = "Python API for Synology DSM";
    homepage = "https://github.com/hacf-fr/synologydsm-api";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
