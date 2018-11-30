{ stdenv
, buildPythonPackage
, fetchPypi
, pillow
}:

buildPythonPackage rec {
  pname = "pillowfight";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mh1nhcjjgv7x134sv0krri59ng8bp2w6cwsxc698rixba9f3g0m";
  };

  propagatedBuildInputs = [ pillow ];

  meta = with stdenv.lib; {
    description = "Pillow Fight";
    homepage = "https://github.com/beanbaginc/pillowfight";
    license = licenses.mit;
  };

}
