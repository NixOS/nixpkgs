{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pygmars";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "0wghk4nzplpl26iwrgvm0n9x88nyxlcxz4ywss4nwdr4hfccl28l";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pygmars"
  ];

  meta = with lib; {
    description = "Python lexing and parsing library";
    homepage = "https://github.com/nexB/pygmars";
    changelog = "https://github.com/nexB/pygmars/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
