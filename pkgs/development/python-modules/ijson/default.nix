{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ijson";
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "135rwh7izzmj4lwkrfb9xw4ik0gcwjz34ygnmx3vyvki2xbbp2xp";
  };

  doCheck = false; # something about yajl

  meta = with stdenv.lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/isagalaev/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
