{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2020.1.17";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = version;
    sha256 = "08qcisiscnx74pwavh3ai3lg92zfrikwzr06p700kwk1gp8xhf3v";
  };

  # tests require network connection
  doCheck = false;

  meta = with lib; {
    description = "Chromium HSTS Preload list as a Python package and updated daily";
    homepage = https://github.com/sethmlarson/hstspreload;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
