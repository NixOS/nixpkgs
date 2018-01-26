{ stdenv, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  version = "3.0.2";
  pname = "robotframework";
  disabled = isPy3k;
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/r/robotframework/${name}.tar.gz";
    sha256 = "1xqzxv00lxf9xi4vdxdsyd1bfmx18gi96vrnijpzj9w2aqrz4610";
  };

  meta = with stdenv.lib; {
    description = "Generic test automation framework";
    homepage = http://robotframework.org/;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
