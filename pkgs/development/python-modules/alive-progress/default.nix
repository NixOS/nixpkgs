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
    hash = "sha256-2ymLdmaV7mO6tp5bjmbL/67xLP7Srfpt5m8YhOHGmWQ=";
    # Avoid downloading heavy images in img directory
    sparseCheckout = [
      "alive_progress"
      "tests"
    ];
  };

  postInstall = ''
    mkdir -p $out/share/doc/python${python.pythonVersion}-$pname-$version/
    mv $out/LICENSE $out/share/doc/python${python.pythonVersion}-$pname-$version/
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
    changelog = "https://github.com/rsalmei/alive-progress/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thiagokokada ];
  };
}
