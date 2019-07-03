{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, attrs
, bitstruct
, future
, pathlib2
, typing
, lxml
, xlwt
, xlrd
, XlsxWriter
, pyyaml
, pytest
}:

buildPythonPackage rec {
  pname = "canmatrix";
  version = "0.7";

  # uses fetchFromGitHub as PyPi release misses test/ dir
  src = fetchFromGitHub {
    owner = "ebroecker";
    repo = pname;
    rev = version;
    sha256 = "0q8qb282nfgirl8r2i9c8whm3hvr14ig2r42ssgnv2hya971cwjq";
  };

  propagatedBuildInputs = [
    # required
    attrs
    bitstruct
    future
    pathlib2
    # optional
    lxml
    xlwt
    xlrd
    XlsxWriter
    pyyaml
  ] ++ lib.optional (pythonOlder "3.5") typing;

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest -s src/canmatrix
  '';

  meta = with lib; {
    homepage = https://github.com/ebroecker/canmatrix;
    description = "Support and convert several CAN (Controller Area Network) database formats .arxml .dbc .dbf .kcd .sym fibex xls(x)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sorki ];
  };
}

