{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, attrs
, bitstruct
, click
, future
, pathlib2
, typing ? null
, lxml
, xlwt
, xlrd
, XlsxWriter
, pyyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "canmatrix";
  version = "0.9.3";

  # uses fetchFromGitHub as PyPi release misses test/ dir
  src = fetchFromGitHub {
    owner = "ebroecker";
    repo = pname;
    rev = version;
    sha256 = "sha256-9FupG1VmROgsxYhsafQYPPqG0xEOAYYK8QDOIBNzE0Y=";
  };

  propagatedBuildInputs = [
    # required
    attrs
    bitstruct
    click
    future
    pathlib2
    # optional
    lxml
    xlwt
    xlrd
    XlsxWriter
    pyyaml
  ] ++ lib.optional (pythonOlder "3.5") typing;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version = versioneer.get_version()" "version = \"${version}\""
  '';

  checkInputs = [ pytestCheckHook ];
  # long_envvar_name_imports requires stable key value pair ordering
  pytestFlagsArray = [ "-s src/canmatrix" ];
  disabledTests = [ "long_envvar_name_imports" ];
  pythonImportsCheck = [ "canmatrix" ];

  meta = with lib; {
    homepage = "https://github.com/ebroecker/canmatrix";
    description = "Support and convert several CAN (Controller Area Network) database formats .arxml .dbc .dbf .kcd .sym fibex xls(x)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sorki ];
  };
}

