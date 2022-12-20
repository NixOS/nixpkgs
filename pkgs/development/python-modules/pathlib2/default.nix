{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
, scandir ? null
, glibcLocales
, mock
, typing
}:

buildPythonPackage rec {
  pname = "pathlib2";
  version = "2.3.7.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-n+DtrYmLg8DD4ZnIQrJ+0hZkXS4Xd1ey3Wc4TUETxkE=";
  };

  propagatedBuildInputs = [ six ]
    ++ lib.optionals (pythonOlder "3.5") [ scandir typing ];
  checkInputs = [ glibcLocales ]
    ++ lib.optional (pythonOlder "3.3") mock;

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  meta = with lib; {
    description = "This module offers classes representing filesystem paths with semantics appropriate for different operating systems.";
    homepage = "https://pypi.org/project/pathlib2/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
