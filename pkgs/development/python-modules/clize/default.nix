{ stdenv
, buildPythonPackage
, fetchPypi
, dateutil
, sigtools
}:

buildPythonPackage rec {
  pname = "clize";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xkr3h404d7pgj5gdpg6bddv3v3yq2hgx8qlwkgw5abg218k53hm";
  };

  buildInputs = [ dateutil ];
  propagatedBuildInputs = [ sigtools ];

  meta = with stdenv.lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
  };

}
