{
  lib,
  about-time,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  graphemeu,
  pytestCheckHook,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "alive-progress";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rsalmei";
    repo = "alive-progress";
    tag = "v${version}";
    hash = "sha256-DxyTGY72uVKHqZZQ4jj4jVdfZAKkgAtHJ7VBI/dM6DQ=";
  };

  postInstall = ''
    mkdir -p $out/share/doc/python${python.pythonVersion}-$pname-$version/
    mv $out/LICENSE $out/share/doc/python${python.pythonVersion}-$pname-$version/
  '';

  build-system = [ setuptools ];

  dependencies = [
    about-time
    graphemeu
  ];

  pythonRelaxDeps = [
    "about_time"
    "graphemeu"
  ];

  nativeCheckInputs = [
    click
    pytestCheckHook
  ];

  pythonImportsCheck = [ "alive_progress" ];

  meta = {
    description = "New kind of Progress Bar, with real-time throughput, ETA, and very cool animations";
    homepage = "https://github.com/rsalmei/alive-progress";
    changelog = "https://github.com/rsalmei/alive-progress/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thiagokokada ];
  };
}
