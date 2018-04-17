{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
, scandir
, glibcLocales
, mock
}:

if !(pythonOlder "3.4") then null else buildPythonPackage rec {
  pname = "pathlib2";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d32550b75a818b289bd4c1f96b60c89957811da205afcceab75bc8b4857ea5b3";
  };

  propagatedBuildInputs = [ six ] ++ lib.optional (pythonOlder "3.5") scandir;
  checkInputs = [ glibcLocales ] ++ lib.optional (pythonOlder "3.3") mock;

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
    sed -i test_pathlib2.py -e "s@hasattr(pwd, 'getpwall')@False@"
  '';

  meta = {
    description = "This module offers classes representing filesystem paths with semantics appropriate for different operating systems.";
    homepage = https://pypi.python.org/pypi/pathlib2/;
    license = with lib.licenses; [ mit ];
  };
}
