{ stdenv, buildPythonPackage, fetchFromGitHub
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

  checkInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [
    enum-compat
    click
    pyscard
    pycountry
    terminaltables
  ];

  # argparse is part of the standardlib
  prePatch = ''
    substituteInPlace setup.py \
      --replace '"argparse==1.4.0",' ""
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/russss/python-emv";
    description = "Implementation of the EMV chip-and-pin smartcard protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
