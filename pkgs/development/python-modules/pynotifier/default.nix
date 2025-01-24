{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  libnotify,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pynotifier";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "YuriyLisovskiy";
    repo = "pynotifier";
    rev = version;
    hash = "sha256-xS3hH3cyqgDD7uoWkIYXpQAh7SN7XJ/qMfB0Vq5bva0=";
  };

  postPatch = ''
    substituteInPlace pynotifier/backends/platform/linux.py \
      --replace-fail \
        'shutil.which("notify-send")' \
        '"${lib.getExe' libnotify "notify-send"}"'
  '';

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pynotifier" ];

  meta = with lib; {
    description = "Module for sending notifications";
    homepage = "https://github.com/YuriyLisovskiy/pynotifier";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
