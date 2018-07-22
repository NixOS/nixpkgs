{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, lxml
, xlwt
, xlrd
, XlsxWriter
, pyyaml
, future }:

buildPythonPackage rec {
  pname = "canmatrix";
  version = "0.6";

  # uses fetchFromGitHub as PyPi release misses test/ dir
  src = fetchFromGitHub {
    owner = "ebroecker";
    repo = pname;
    rev = version;
    sha256 = "1lb0krhchja2jqfsh5lsfgmqcchs1pd38akvc407jfmll96f4yqz";
  };

  checkPhase = ''
    cd test
    ${python.interpreter} ./test.py
  '';

  propagatedBuildInputs =
    [ lxml
      xlwt
      xlrd
      XlsxWriter
      pyyaml
      future
    ];

  meta = with lib; {
    homepage = https://github.com/ebroecker/canmatrix;
    description = "Support and convert several CAN (Controller Area Network) database formats .arxml .dbc .dbf .kcd .sym fibex xls(x)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sorki ];
  };
}

