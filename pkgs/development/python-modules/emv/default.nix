{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  pyscard,
  pycountry,
  terminaltables,
  pytestCheckHook,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "emv";
  version = "1.0.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "russss";
    repo = "python-emv";
    tag = "v${version}";
    hash = "sha256-MnaeQZ0rA3i0CoUA6HgJQpwk5yo4rm9e+pc5XzRd1eg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"enum-compat==0.0.3",' "" \
      --replace-fail '"argparse==1.4.0",' "" \
      --replace-fail "click==7.1.2" "click" \
      --replace-fail "pyscard==2.0.0" "pyscard" \
      --replace-fail "pycountry==20.7.3" "pycountry" \
      --replace-fail "terminaltables==3.1.0" "terminaltables"
  '';

  build-system = [ setuptools ];

  dependencies = [
    click
    pyscard
    pycountry
    terminaltables
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "emv" ];

  meta = with lib; {
    description = "Implementation of the EMV chip-and-pin smartcard protocol";
    homepage = "https://github.com/russss/python-emv";
    changelog = "https://github.com/russss/python-emv/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    mainProgram = "emvtool";
  };
}
