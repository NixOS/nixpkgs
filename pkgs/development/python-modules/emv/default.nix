{ lib, buildPythonPackage, fetchFromGitHub
, click, enum-compat, pyscard, pycountry, terminaltables
, pytestCheckHook, pythonOlder
}:

buildPythonPackage rec {
  pname = "emv";
  version = "1.0.11";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "russss";
    repo = "python-emv";
    rev = "v${version}";
    hash = "sha256:1715hcba3fdi0i5awnrjdjnk74p66sxm9349pd8bb717zrh4gpj7";
  };

  postPatch = ''
    # argparse is part of the standard libary since python 2.7/3.2
    sed -i '/argparse==1.4.0/d' setup.py

    substituteInPlace setup.py \
      --replace "click==7.1.2" "click" \
      --replace "pyscard==2.0.0" "pyscard"
  '';

  propagatedBuildInputs = [
    enum-compat
    click
    pyscard
    pycountry
    terminaltables
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/russss/python-emv";
    description = "Implementation of the EMV chip-and-pin smartcard protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
