{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  name = "bitvector-for-humans";
  version = "0.14.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "bitvector";
    rev = "refs/tags/${version}";
    hash = "sha256-GVTRD83tq/Hea53US4drOD5ruoYCLTVd24aZOSdDsSo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace "poetry.masonry" "poetry.core.masonry"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bitvector" ];

  meta = {
    homepage = "https://github.com/JnyJny/bitvector";
    description = "Bit Vector for Humans™";
    changelog = "https://github.com/JnyJny/bitvector/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
