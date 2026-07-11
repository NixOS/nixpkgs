{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "pathlib2";
  version = "2.3.7.post1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n+DtrYmLg8DD4ZnIQrJ+0hZkXS4Xd1ey3Wc4TUETxkE=";
  };

  propagatedBuildInputs = [
    six
  ];

  meta = {
    description = "This module offers classes representing filesystem paths with semantics appropriate for different operating systems";
    homepage = "https://pypi.org/project/pathlib2/";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
}
