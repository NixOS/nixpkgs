{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "click";
  version = "5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0njsm0wn31l21bi118g5825ma5sa3rwn7v2x4wjd7yiiahkri337";
  };

  meta = with stdenv.lib; {
    homepage = http://click.pocoo.org/;
    description = "Create beautiful command line interfaces in Python";
    longDescription = ''
      A Python package for creating beautiful command line interfaces in a
      composable way, with as little code as necessary.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ mog ];
  };
}
