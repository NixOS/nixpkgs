{ stdenv, buildPythonPackage, fetchurl, six, async-timeout }:
buildPythonPackage rec {
  version = "2.2.0";
  pname = "asgiref";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgiref/${name}.tar.gz";
    sha256 = "1fmrd749hqxwicnivvgrcw812gbj2zm49zcnkghh9yxbkjfcvxcv";
  };

  propagatedBuildInputs = [ six async-timeout ];

  meta = with stdenv.lib; {
    description = "Reference ASGI adapters and channel layers";
    license = licenses.bsd3;
    homepage = https://github.com/django/asgiref;
  };
}
