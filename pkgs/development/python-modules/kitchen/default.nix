{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "kitchen";
  version = "1.2.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ggv3p4x8jvmmzhp0xm00h6pvh1g0gmycw71rjwagnrj8n23vxrq";
  };

  meta = with stdenv.lib; {
    description = "Kitchen contains a cornucopia of useful code";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ mornfall ];
  };
}
