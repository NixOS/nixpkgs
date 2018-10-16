{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, nose
}:

buildPythonPackage rec {
  pname = "pyRFC3339";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pp648xsjaw9h1xq2mgwzda5wis2ypjmzxlksc1a8grnrdmzy155";
  };

  propagatedBuildInputs = [ pytz ];
  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Generate and parse RFC 3339 timestamps";
    homepage = https://github.com/kurtraschke/pyRFC3339;
    license = licenses.mit;
  };

}
