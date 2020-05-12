{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "EasyProcess";
  version = "0.2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06zaxydyqvb5mk5kxs6y3pjbq5nm6lmi3h5g3y41xpic48q5wsv3";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Easy to use python subprocess interface";
    homepage = "https://github.com/ponty/EasyProcess";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}
