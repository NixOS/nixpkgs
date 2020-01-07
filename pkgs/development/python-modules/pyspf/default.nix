{ lib, python, buildPythonPackage, fetchFromGitHub, pydns }:

buildPythonPackage rec {
  pname = "pyspf";
  version = "2.0.14";

  src = fetchFromGitHub {
    owner = "sdgathman";
    repo = pname;
    rev = "pyspf-${version}";
    sha256 = "0bmimlmwrq9glnjc4i6pwch30n3y5wyqmkjfyayxqxkfrixqwydi";
  };

  propagatedBuildInputs = [ pydns ];

  # requires /etc/resolv.conf to exist
  doCheck = false;

  meta = with lib; {
    homepage = http://bmsi.com/python/milter.html;
    description = "Python API for Sendmail Milters (SPF)";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2;
  };
}
