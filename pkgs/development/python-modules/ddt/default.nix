{ lib
, buildPythonPackage
, fetchFromGitHub
, six, pyyaml, mock
, pytestCheckHook
, enum34
, isPy3k
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.4.4";

  src = fetchFromGitHub {
     owner = "txels";
     repo = "ddt";
     rev = "1.4.4";
     sha256 = "1n0xyvwyfqalyz5jvpg0yd7dfi753in4707vpcxxjjjanmskksxb";
  };

  checkInputs = [ six pyyaml mock pytestCheckHook ];

  propagatedBuildInputs = lib.optionals (!isPy3k) [
    enum34
  ];

  meta = with lib; {
    description = "Data-Driven/Decorated Tests, a library to multiply test cases";
    homepage = "https://github.com/txels/ddt";
    license = licenses.mit;
  };

}
