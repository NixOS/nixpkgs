{ lib
, stdenv
, pythonOlder
, rustPlatform
, fetchFromGitHub
, buildPythonPackage
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
  version = "3.6.5";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ijl";
    repo = pname;
    rev = version;
    sha256 = "1f8gc62w4hncrz8xkfw730cfqnk5433qswz3rba3pvvd7ldj5658";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "0jlhzdnfyk7hnn74rz9zbx51sdjs6rwlzfl1g62h58x28xh6m6gb";
  };

  format = "pyproject";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  checkInputs = [
    numpy
    psutil
    pytestCheckHook
    python-dateutil
    pytz
    xxhash
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
