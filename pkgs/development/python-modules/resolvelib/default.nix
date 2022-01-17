{ version
, sha256
, lib
, buildPythonPackage
, fetchFromGitHub
, commentjson
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "resolvelib";
  inherit version;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "resolvelib";
    rev = version;
    inherit sha256;
  };

  checkInputs = [
    commentjson
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Resolve abstract dependencies into concrete ones";
    homepage = "https://github.com/sarugaku/resolvelib";
    license = licenses.isc;
    maintainers = with maintainers; [ hexa ];
  };
}
