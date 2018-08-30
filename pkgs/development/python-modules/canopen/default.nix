{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, can
, canmatrix }:

buildPythonPackage rec {
  pname = "canopen";
  version = "0.5.1";

  # use fetchFromGitHub until version containing test/sample.eds
  # is available on PyPi
  # https://github.com/christiansandberg/canopen/pull/57

  src = fetchFromGitHub {
    owner = "christiansandberg";
    repo = "canopen";
    rev = "b20575d84c3aef790fe7c38c5fc77601bade0ea4";
    sha256 = "1qg47qrkyvyxiwi13sickrkk89jp9s91sly2y90bz0jhws2bxh64";
  };

  #src = fetchPypi {
  #  inherit pname version;
  #  sha256 = "0806cykarpjb9ili3mf82hsd9gdydbks8532nxgz93qzg4zdbv2g";
  #};

  # test_pdo failure https://github.com/christiansandberg/canopen/issues/58
  doCheck = false;

  propagatedBuildInputs =
    [ can
      canmatrix
    ];

  checkInputs = [ nose ];

  meta = with lib; {
    homepage = https://github.com/christiansandberg/canopen/;
    description = "CANopen stack implementation";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sorki ];
  };
}
