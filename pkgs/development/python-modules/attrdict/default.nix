{ stdenv, buildPythonPackage, fetchPypi, coverage, nose, six }:

buildPythonPackage rec {
  pname = "attrdict";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lrailzxy40dx6sn1hbpnpqfbg7ar75dfj41kx0480wyh39vdbl6";
  };

  propagatedBuildInputs = [ coverage nose six ];

  meta = with stdenv.lib; {
    description = "A dict with attribute-style access";
    homepage = https://github.com/bcj/AttrDict;
    license = licenses.mit;
  };
}
