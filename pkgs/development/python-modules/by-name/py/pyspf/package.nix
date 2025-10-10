{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  py3dns,
}:

buildPythonPackage rec {
  pname = "pyspf";
  version = "2.0.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdgathman";
    repo = "pyspf";
    rev = "pyspf-${version}";
    sha256 = "0bmimlmwrq9glnjc4i6pwch30n3y5wyqmkjfyayxqxkfrixqwydi";
  };

  propagatedBuildInputs = [ py3dns ];

  # requires /etc/resolv.conf to exist
  doCheck = false;

  meta = with lib; {
    homepage = "http://bmsi.com/python/milter.html";
    description = "Python API for Sendmail Milters (SPF)";
    maintainers = [ ];
    license = licenses.gpl2;
  };
}
