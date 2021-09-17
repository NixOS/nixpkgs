{ lib, buildPythonPackage, fetchPypi
, asttokens, colorama, executing, pygments
}:

buildPythonPackage rec {
  pname = "icecream";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47e00e3f4e8477996e7dc420b6fa8ba53f8ced17de65320fedb5b15997b76589";
  };

  propagatedBuildInputs = [ asttokens colorama executing pygments ];

  meta = with lib; {
    description = "A little library for sweet and creamy print debugging";
    homepage = "https://github.com/gruns/icecream";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
