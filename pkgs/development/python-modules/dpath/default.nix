{ stdenv, fetchPypi, buildPythonPackage
, mock, nose
}:

buildPythonPackage rec {
  pname = "dpath";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gr7816pnzbyh9h1ia0qz0q1f9zfzacwb8dc36js8hw8x14myqqg";
  };

  checkInputs = [ mock nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/akesterson/dpath-python;
    license = [ licenses.mit ];
    description = "A python library for accessing and searching dictionaries via /slashed/paths ala xpath";
    maintainers = [ maintainers.mmlb ];
  };
}
