{ lib
, stdenv
, pythonOlder
, rustPlatform
, fetchFromGitHub
, buildPythonPackage
, cffi
, libiconv
, numpy
, psutil
, pytestCheckHook
, python-dateutil
, pytz
, xxhash
}:

buildPythonPackage rec {
  pname = "orjson";
  version = "3.8.9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ijl";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0/yvXXj+z2jBEAGxO4BxMnx1zqUoultYSYfSkKs+hKY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-ogkTRRykLF2dTOxilsfwsRH+Au/O0e1kL1e9sFOFLeY=";
  };

  nativeBuildInputs = [
    cffi
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [
    numpy
    psutil
    pytestCheckHook
    python-dateutil
    pytz
    xxhash
  ];

  pythonImportsCheck = [
    "orjson"
  ];

  meta = with lib; {
    description = "Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy";
    homepage = "https://github.com/ijl/orjson";
    changelog = "https://github.com/ijl/orjson/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ misuzu ];
  };
}
