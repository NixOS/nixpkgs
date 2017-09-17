{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pyobjc";
  version = "4.0b1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16bng6960c1m57nnh1l09ycnyimrqzw9mx9pnyjxn5zzm5kalr37";
  };

  meta = {
    description = "A bridge between the Python and Objective-C programming languages";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ sauyon ];
    homepage = https://pythonhosted.org/pyobjc/;
  };
}
