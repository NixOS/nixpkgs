{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2019.12.25";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = version;
    sha256 = "1aa7jccwldxw3s0z668qqb0i0plsark1q3jvkmqkyp645w5bfilk";
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
