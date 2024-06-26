{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "bitvector-for-humans";
  version = "0.14.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "bitvector";
    rev = version;
    hash = "sha256-GVTRD83tq/Hea53US4drOD5ruoYCLTVd24aZOSdDsSo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry>=0.12' 'poetry-core' \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api'
  '';

  nativeBuildInputs = [
    poetry-core
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bitvector" ];

  meta = with lib; {
    homepage = "https://github.com/JnyJny/bitvector";
    description = "This simple bit vector implementation aims to make addressing single bits a little less fiddly.";
    license = licenses.asl20;
    maintainers = with maintainers; [ conni2461 ];
  };
}
