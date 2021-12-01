{ lib
, buildPythonPackage
, fetchFromGitHub
, pymysql
, pytest
, isPy27
, fetchpatch
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

  patches = [
    (fetchpatch {
      # vendor functions previously provided by pymysql.util
      url = "https://github.com/aio-libs/aiomysql/pull/554/commits/919b997a9de7f53d721af76762fba425e306531e.patch";
      sha256 = "V1VYyqr6RwTXoVoGVyMuJst6uqTuuHbpMOpLoVZO1XA=";
    })
  ];

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
