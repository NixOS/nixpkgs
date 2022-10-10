{ lib, python, buildPythonPackage, fetchFromGitHub, libmilter, bsddb3, pydns }:

buildPythonPackage rec {
  pname = "pymilter";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "sdgathman";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-gZUWEDVZfDRiOOdG3lpiQldHxm/93l8qYVOHOEpHhzQ=";
  };

  buildInputs = [ libmilter ];
  propagatedBuildInputs = [ bsddb3 pydns ];

  preBuild = ''
    sed -i 's/import thread/import _thread as thread/' Milter/greylist.py
  '';

  # requires /etc/resolv.conf
  doCheck = false;

  meta = with lib; {
    homepage = "http://bmsi.com/python/milter.html";
    description = "Python bindings for libmilter api";
    maintainers = with maintainers; [ yorickvp ];
    license = licenses.gpl2;
  };
}
