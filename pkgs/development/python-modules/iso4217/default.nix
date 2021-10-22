{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchurl
, pytestCheckHook
, python
}:
let
  table = fetchurl {
    # See https://github.com/dahlia/iso4217/blob/main/setup.py#L18
    url = "http://www.currency-iso.org/dam/downloads/lists/list_one.xml";
    sha256 = "0frhicc7s8gqglr41hzx61fic3ckvr4sg773ahp1s28n5by3y7ac";
  };
in
buildPythonPackage rec {
  pname = "iso4217";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = pname;
    rev = version;
    sha256 = "0mdpf5a0xr5lrcfgvqi1sdn7ln2w6pkc3lg0laqkbx5mhxky0fla";
  };

  checkInputs = [
    pytestCheckHook
  ];

  preBuild = ''
    # The table is already downloaded
    export ISO4217_DOWNLOAD=0
    # Copy the table file to satifiy the build process
    cp -r ${table} $pname/table.xml
  '';

  postInstall = ''
    # Copy the table file
    cp -r ${table} $out/${python.sitePackages}/$pname/table.xml
  '';

  pytestFlagsArray = [ "$pname/test.py" ];

  pythonImportsCheck = [ "iso4217" ];

  meta = with lib; {
    description = "ISO 4217 currency data package for Python";
    homepage = "https://github.com/dahlia/iso4217";
    license = with licenses; [ publicDomain ];
    maintainers = with maintainers; [ fab ];
  };
}
