{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  python-dateutil,
  ephem,
  pytz,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lunarcalendar";
  version = "0.0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wolfhong";
    repo = "LunarCalendar";
    rev = "885418ea1a2a90b7e0bbe758919af9987fb2863b";
    hash = "sha256-AhxCWWqCjlOroqs4pOSZTWoIQT8a1l/D2Rxuw1XUoU8=";
  };

  propagatedBuildInputs = [
    python-dateutil
    ephem
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lunarcalendar" ];

  meta = {
    homepage = "https://github.com/wolfhong/LunarCalendar";
    description = "Lunar-Solar Converter, containing a number of lunar and solar festivals in China";
    mainProgram = "lunar-find";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
