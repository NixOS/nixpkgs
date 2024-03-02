{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, pyscard
, pycountry
, terminaltables
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "emv";
  version = "1.0.14";
  format = "setuptools";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "russss";
    repo = "python-emv";
    rev = "v${version}";
    hash = "sha256-MnaeQZ0rA3i0CoUA6HgJQpwk5yo4rm9e+pc5XzRd1eg=";
  };

  propagatedBuildInputs = [
    click
    pyscard
    pycountry
    terminaltables
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"enum-compat==0.0.3",' "" \
      --replace '"argparse==1.4.0",' "" \
      --replace "click==7.1.2" "click" \
      --replace "pyscard==2.0.0" "pyscard" \
      --replace "pycountry==20.7.3" "pycountry" \
      --replace "terminaltables==3.1.0" "terminaltables"
  '';

  pythonImportsCheck = [
    "emv"
  ];

  meta = with lib; {
    description = "Implementation of the EMV chip-and-pin smartcard protocol";
    homepage = "https://github.com/russss/python-emv";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
