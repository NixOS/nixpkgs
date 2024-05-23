{
  lib,
  astral,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  pytz,
}:

buildPythonPackage rec {
  pname = "hdate";
  version = "0.10.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "py-libhdate";
    repo = "py-libhdate";
    rev = "refs/tags/v${version}";
    hash = "sha256-NF2ZA9ruW7sL2tLY11VAtyPRxGg2o5/mpv3ZsH/Zxb8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pytz = ">= 2020.0"' 'pytz = "*"' \
      --replace 'astral = {version = "^2.2", python = "^3.6"}' 'astral = "*"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    astral
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "hdate" ];

  meta = with lib; {
    description = "Python module for Jewish/Hebrew date and Zmanim";
    homepage = "https://github.com/py-libhdate/py-libhdate";
    changelog = "https://github.com/py-libhdate/py-libhdate/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
