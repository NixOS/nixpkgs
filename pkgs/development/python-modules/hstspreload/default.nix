{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2020.5.19";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = version;
    sha256 = "09a5vajzw3f2kpdq9ydzx1f840xmdmzb6br3ns79mnqnsw6nfs6z";
  };

  # tests require network connection
  doCheck = false;

  meta = with lib; {
    description = "Chromium HSTS Preload list as a Python package and updated daily";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
