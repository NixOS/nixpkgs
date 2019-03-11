{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, nose
}:

buildPythonPackage rec {
  pname = "pyRFC3339";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06jv7ar7lpvvk0dixzwdr3wgm0g1lipxs429s2z7knwwa7hwpf41";
  };

  propagatedBuildInputs = [ pytz ];
  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Generate and parse RFC 3339 timestamps";
    homepage = https://github.com/kurtraschke/pyRFC3339;
    license = licenses.mit;
  };

}
