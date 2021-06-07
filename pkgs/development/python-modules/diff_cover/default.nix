{ lib, buildPythonPackage, fetchPypi
, chardet
, inflect
, jinja2
, jinja2_pluralize
, pygments
, six
# test dependencies
, coverage
, mock
, nose
, pycodestyle
, pyflakes
, pylint
, pytest
}:

buildPythonPackage rec {
  pname = "diff_cover";
  version = "5.0.1";

  preCheck = ''
    export LC_ALL=en_US.UTF-8;
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "e80f7a4979b7a9d373903776588279ed2898f17729e608255c4119462c822edb";
  };

  propagatedBuildInputs = [ chardet jinja2 jinja2_pluralize pygments six inflect ];

  checkInputs = [ mock coverage pytest nose pylint pyflakes pycodestyle ];

  # ignore tests which try to write files
  checkPhase = ''
    pytest -k 'not added_file_pylint_console and not file_does_not_exist'
  '';

  meta = with lib; {
    description = "Automatically find diff lines that need test coverage";
    homepage = "https://github.com/Bachmann1234/diff-cover";
    license = licenses.asl20;
    maintainers = with maintainers; [ dzabraev ];
  };
}
