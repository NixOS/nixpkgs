{ lib
, buildPythonPackage
, enum-compat
, fetchFromGitHub
, pytestCheckHook
, unicodecsv
, six
}:

buildPythonPackage rec {
  pname = "python-registry";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = pname;
    rev = version;
    sha256 = "0gwx5jcribgmmbz0ikhz8iphz7yj2d2nmk24nkdrjd3y5irly11s";
  };

  propagatedBuildInputs = [
    enum-compat
    unicodecsv
  ];

  checkInputs = [
    pytestCheckHook
    six
  ];

  disabledTestPaths = [
    "samples"
  ];

  pythonImportsCheck = [
    "Registry"
  ];

  meta = with lib; {
    description = "Pure Python parser for Windows Registry hives";
    homepage = "https://github.com/williballenthin/python-registry";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
