{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  jinja2,
  pytest,
  rich,
  pythonOlder,
  syrupy,
  textual,
}:

buildPythonPackage rec {
  pname = "pytest-textual-snapshot";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "pytest-textual-snapshot";
    tag = "v${version}";
    hash = "sha256-ItwwaODnlya/T0Fk5DOPRLoBOwkUN5wq69cELuvy/Js=";
  };

  nativeBuildInputs = [ poetry-core ];

  buildInputs = [ pytest ];
  # The script looks for `resources/snapshot_report_template.jinja2` in the parent folder which
  # is lib/python3.X/site-packages
  # Let's avoid to have a random 'resources' folder in the PYTHONPATH.
  # Instead, we move this `resources` folder in `$out/share` (see postInstall below) and patch the
  # path in the script.
  postPatch = ''
    substituteInPlace pytest_textual_snapshot.py \
      --replace-fail \
        "this_file_path.parent" \
        "Path('$out/share/pytest-textual-snapshot/')"
  '';

  propagatedBuildInputs = [
    jinja2
    rich
    syrupy
    textual
  ];

  pythonRelaxDeps = [
    "syrupy"
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pytest_textual_snapshot" ];

  postInstall = ''
    mkdir -p $out/share/pytest-textual-snapshot/
    cp -r resources $out/share/pytest-textual-snapshot/
  '';

  meta = with lib; {
    description = "Snapshot testing for Textual applications";
    homepage = "https://github.com/Textualize/pytest-textual-snapshot";
    changelog = "https://github.com/Textualize/pytest-textual-snapshot/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
