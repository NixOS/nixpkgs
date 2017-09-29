{ stdenv, buildPythonPackage, fetchurl
, zope_testrunner, six, chardet}:

buildPythonPackage rec {
  pname = "ghdiff";
  version = "0.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/g/ghdiff/${name}.tar.gz";
    sha256 = "17mdhi2sq9017nq8rkjhhc87djpi5z99xiil0xz17dyplr7nmkqk";
  };

  buildInputs = [ zope_testrunner ];
  propagatedBuildInputs = [ six chardet ];

  meta = with stdenv.lib; {
    homepage =  https://github.com/kilink/ghdiff;
    license = licenses.mit;
    description = "Generate Github-style HTML for unified diffs.";
    maintainers = [ maintainers.mic92 ];
  };
}
