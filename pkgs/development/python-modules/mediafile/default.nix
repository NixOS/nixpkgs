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
  version = "0.10.1";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2h17FA0GTY4R+WhZiQtPFYf6gH7XLbI3aOB/nUXFtJI=";
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
