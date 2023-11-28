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
, xlsxwriter
, pyyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "canmatrix";
  version = "1.0";

  # uses fetchFromGitHub as PyPi release misses test/ dir
  src = fetchFromGitHub {
    owner = "ebroecker";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-UUJnLVt+uOj8Eav162btprkUeTemItGrSnBBB9UhJJI=";
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
    xlsxwriter
    pyyaml
  ] ++ lib.optional (pythonOlder "3.5") typing;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version = versioneer.get_version()" "version = \"${version}\""
  '';

  nativeCheckInputs = [ pytestCheckHook ];
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

