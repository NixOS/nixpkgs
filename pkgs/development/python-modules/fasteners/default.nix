{ lib
, buildPythonPackage
, fetchFromGitHub
, diskcache
, more-itertools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fasteners";
  version = "0.17.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "harlowja";
    repo = pname;
    rev = version;
    hash = "sha256-FVhHp8BZ/wQQyr5AcuDo94LlflixhjZ0SnheSdHuDVQ=";
  };

  checkInputs = [
    diskcache
    more-itertools
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A python package that provides useful locks";
    homepage = "https://github.com/harlowja/fasteners";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
