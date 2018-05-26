{ lib, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  name = "scandir-${version}";
  version = "1.7";

  src = fetchurl {
    url = "mirror://pypi/s/scandir/${name}.tar.gz";
    sha256 ="0gbnhjzg42rj87ljv9kb648rfxph69ly3c8r9841dxy4d7l5pmdj";
  };

  meta = with lib; {
    description = "A better directory iterator and faster os.walk()";
    homepage = https://github.com/benhoyt/scandir;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
