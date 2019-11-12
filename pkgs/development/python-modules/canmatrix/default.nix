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
  version = "0.8";

  # uses fetchFromGitHub as PyPi release misses test/ dir
  src = fetchFromGitHub {
    owner = "ebroecker";
    repo = pname;
    rev = version;
    sha256 = "1wzflapyj2j4xsi7d7gfmznmxbgr658n092xyq9nac46rbhpcphg";
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

