{ stdenv
, buildPythonPackage
, fetchPypi
,
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "18.12.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1phn1av57jbm166facjk6r8gw4pf886q4wymjc443k8m5c5h5i4f";
  };

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/flyingcircus/pycountry;
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = licenses.lgpl2;
  };

}
