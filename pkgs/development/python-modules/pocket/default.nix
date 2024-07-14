{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pocket";
  version = "0.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kHvxahn66cIID3mdl53kyNqjbW0o6Gzrn8F9bwvbibk=";
  };

  buildInputs = [ requests ];

  meta = with lib; {
    description = "Wrapper for the pocket API";
    homepage = "https://github.com/tapanpandita/pocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
