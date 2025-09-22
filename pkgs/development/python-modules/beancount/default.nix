{
  lib,
  bison,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  flex,
  gnupg,
  meson,
  meson-python,
  pytestCheckHook,
  python-dateutil,
  regex,
}:

buildPythonPackage rec {
  version = "3.2.0";
  pname = "beancount";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beancount";
    tag = version;
    hash = "sha256-XWTgaBvB4/SONL44afvprZwJUVrkoda5XLGNxad0kec=";
  };

  build-system = [
    meson
    meson-python
  ];

  dependencies = [
    click
    python-dateutil
    regex
  ];

  nativeBuildInputs = [
    bison
    flex
  ];

  nativeCheckInputs = [
    gnupg
    pytestCheckHook
  ];

  preCheck = ''
    # avoid local paths, relative imports wont resolve correctly
    mv beancount tests
  '';

  pythonImportsCheck = [ "beancount" ];

  meta = {
    homepage = "https://github.com/beancount/beancount";
    changelog = "https://github.com/beancount/beancount/releases/tag/${src.tag}";
    description = "Double-entry bookkeeping computer language";
    longDescription = ''
      A double-entry bookkeeping computer language that lets you define
      financial transaction records in a text file, read them in memory,
      generate a variety of reports from them, and provides a web interface.
    '';
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ alapshin ];
  };
}
