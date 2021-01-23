{ lib
, buildPythonPackage
, fetchFromGitHub
, pymysql
, pytest
, isPy27
}:

buildPythonPackage rec {
  pname = "aiomysql";
  version = "0.0.21";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qvy3phbsxp55161dnppjfx2m1kn82v0irc3xzqw0adfd81vaiad";
  };

  propagatedBuildInputs = [
    pymysql
  ];

  checkInputs = [
    pytest
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "PyMySQL>=0.9,<=0.9.3" "PyMySQL"
  '';

  checkPhase = ''
    pytest
  '';

  # tests require mysql database
  doCheck = false;

  meta = with lib; {
    description = "MySQL driver for asyncio";
    homepage = "https://github.com/aio-libs/aiomysql";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
