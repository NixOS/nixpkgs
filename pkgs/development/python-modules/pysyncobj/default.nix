{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pysyncobj";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "bakwc";
    repo = "PySyncObj";
    rev = version;
    sha256 = "0i7gjapaggkfvys4rgd4krpmh6mxwpzv30ngiwb6ddgp8jx0nzxk";
  };

  propagatedBuildInputs = [ cryptography ];
  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "test_syncobj.py" ];

  meta = with lib; {
    description = "A library for replicating your python class between multiple servers, based on raft protocol";
    homepage = "https://github.com/bakwc/PySyncObj";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
