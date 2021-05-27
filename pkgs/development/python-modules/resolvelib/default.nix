{ lib
, buildPythonPackage
, fetchFromGitHub
, commentjson
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "resolvelib";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "resolvelib";
    rev = version;
    sha256 = "0r7cxwrfvpqz4kd7pdf8fsynzlmi6c754jd5hzd6vssc1zlyvvhx";
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
