{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, mutagen
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "mediafile";
  version = "0.10.0";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Sdb5Hvm4Y344msZGie4PJ88ZmFtWfc0chABtmwnEN/Y=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    mutagen
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mediafile"
  ];

  meta = with lib; {
    description = "Python interface to the metadata tags for many audio file formats";
    homepage = "https://github.com/beetbox/mediafile";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
