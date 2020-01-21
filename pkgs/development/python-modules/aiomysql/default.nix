{ lib
, buildPythonPackage
, fetchFromGitHub
, pymysql
, pytest
, isPy27
}:

buildPythonPackage rec {
  pname = "aiomysql";
  version = "0.0.20";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mxih81zc2k64briirpp5wz4f72l8v05avfyfibaq9fr6lcbih9b";
  };

  propagatedBuildInputs = [
    pymysql
  ];

  checkInputs = [
    pytest
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "PyMySQL>=0.9,<=0.9.2" "PyMySQL"
  '';

  checkPhase = ''
    pytest
  '';

  # tests require mysql database
  doCheck = false;

  meta = with lib; {
    description = "MySQL driver for asyncio";
    homepage = https://github.com/aio-libs/aiomysql;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
