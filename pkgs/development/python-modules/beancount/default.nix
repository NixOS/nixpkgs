{
  lib,
  stdenv,
  bison,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  fetchpatch2,
  flex,
  gnupg,
  meson,
  meson-python,
  pytestCheckHook,
  python-dateutil,
  regex,
}:

buildPythonPackage rec {
  version = "3.2.3";
  pname = "beancount";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beancount";
    tag = version;
    hash = "sha256-WM8SM2ZHphafzXHyVi4Fo9tgsClAnmLsZKZUsf2Twmg=";
  };

  postPatch = ''
    # We don't need the python binary wrappers, since we provide them via nativeBuildInputs
    substituteInPlace pyproject.toml \
      --replace-fail "'flex-bin ; sys_platform == \"linux\" or sys_platform == \"darwin\"'," "" \
      --replace-fail "'bison-bin ; sys_platform == \"linux\" or sys_platform == \"darwin\"'," ""
  '';

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

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Cannot run the gpg-agent. If needed, implement as passthru tests.
    "test_read_encrypted_file"
    "test_include_encrypted"
  ];

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
