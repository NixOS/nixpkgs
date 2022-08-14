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
  version = "3.7.8";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ijl";
    repo = pname;
    rev = version;
    hash = "sha256-K/hLNzwwEeGN6S33Xkfh+ocDHmTmh6yZYcN4vxaAvoQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-kwZg1bC1O6XBI5HBgzahph/0k/RUKEkFIQMMuA1xe4w=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    cffi
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  checkInputs = [
    numpy
    psutil
    pytestCheckHook
    python-dateutil
    pytz
    xxhash
  ];

  disabledTests = [
    # Disable the partial second tests until the following is fixed:
    #
    #   https://github.com/ijl/orjson/issues/293
    #
    "test_datetime_partial_second_zoneinfo"
    "test_datetime_partial_second_pytz"
  ];

  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy";
    homepage = "https://github.com/ijl/orjson";
    license = with licenses; [ asl20 mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ misuzu ];
  };
}
