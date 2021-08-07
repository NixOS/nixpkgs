{ lib
, buildPythonPackage
, fetchFromGitHub
, commentjson
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "resolvelib";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "resolvelib";
    rev = version;
    sha256 = "1fqz75riagizihvf4j7wc3zjw6kmg1dd8sf49aszyml105kb33n8";
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
