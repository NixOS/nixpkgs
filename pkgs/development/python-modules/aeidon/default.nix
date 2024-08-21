{
  lib,
  buildPythonPackage,
  fetchPypi,
  gettext,
  flake8,
  isocodes,
  pytestCheckHook,
  charset-normalizer,
}:

buildPythonPackage rec {
  pname = "aeidon";
  version = "1.15";

  src = fetchPypi {
    pname = "aeidon";
    inherit version;
    sha256 = "sha256-qGpGraRZFVaW1Jys24qvfPo5WDg7Q/fhvm44JH8ulVw=";
  };

  nativeBuildInputs = [
    gettext
    flake8
  ];

  dependencies = [ isocodes ];

  installPhase = ''
    runHook preInstall
    python setup.py --without-gaupol install --prefix=$out
    runHook postInstall
  '';

  nativeCheckInputs = [
    pytestCheckHook
    charset-normalizer
  ];

  # Aeidon is looking in the wrong subdirectory for data
  preCheck = ''
    cp -r data aeidon/
  '';

  pytestFlagsArray = [ "aeidon/test" ];

  disabledTests = [
    # requires gspell to work with gobject introspection
    "test_spell"
  ];

  pythonImportsCheck = [ "aeidon" ];

  meta = with lib; {
    description = "Reading, writing and manipulationg text-based subtitle files";
    homepage = "https://github.com/otsaloma/gaupol";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ erictapen ];
  };

}
