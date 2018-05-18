{ stdenv, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  version = "3.0.3";
  pname = "robotframework";
  disabled = isPy3k;
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/r/robotframework/${name}.tar.gz";
    sha256 = "a5ffe9283c9247c3a1e81228fcc009819d8f94b48768170268a3e6274a998bca";
  };

  meta = with stdenv.lib; {
    description = "Generic test automation framework";
    homepage = http://robotframework.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
