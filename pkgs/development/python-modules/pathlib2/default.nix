{ lib
, buildPythonPackage
, fetchPypi
, six
, glibcLocales
}:

buildPythonPackage rec {
  pname = "pathlib2";
  version = "2.3.7.post1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n+DtrYmLg8DD4ZnIQrJ+0hZkXS4Xd1ey3Wc4TUETxkE=";
  };

  propagatedBuildInputs = [ six ];
  nativeCheckInputs = [ glibcLocales ];

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  meta = with lib; {
    description = "This module offers classes representing filesystem paths with semantics appropriate for different operating systems.";
    homepage = "https://pypi.org/project/pathlib2/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
