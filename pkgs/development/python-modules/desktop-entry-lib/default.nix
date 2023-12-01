{ lib
, buildPythonPackage
, pythonOlder
, pytestCheckHook
, fetchFromGitea
, setuptools
}:

buildPythonPackage rec {
  pname = "desktop-entry-lib";
  version = "3.1";
  pyproject = true;
  disabled = pythonOlder "3.9";

  # We could use fetchPypi, but then the tests won't run
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "JakobDev";
    repo = pname;
    rev = version;
    hash = "sha256-+c+FuLv88wc4yVw3iyFFtfbocnWzTCIe2DS0SWoj+VI=";
  };

  nativeBuildInputs = [ setuptools ];
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "desktop_entry_lib" ];

  meta = with lib; {
    description = "Allows reading and writing .desktop files according to the Desktop Entry Specification";
    homepage = "https://codeberg.org/JakobDev/desktop-entry-lib";
    changelog = "https://codeberg.org/JakobDev/desktop-entry-lib/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ Madouura ];
  };
}
