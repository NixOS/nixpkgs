{ stdenv, buildPythonPackage, fetchPypi
, inflect
, jinja2
, jinja2_pluralize
, pygments
, six
# test dependencies
, coverage
, flake8
, mock
, nose
, pycodestyle
, pyflakes
, pylint
, pytest
}:

buildPythonPackage rec {
  pname = "diff_cover";
  version = "2.6.0";

  preCheck = ''
    export LC_ALL=en_US.UTF-8;
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bsxc9x3yx5dy2r3b3lzi97wz0ma3ncd14jr27n6lbqvl20w92mm";
  };

  propagatedBuildInputs = [ jinja2 jinja2_pluralize pygments six inflect ];

  checkInputs = [ mock coverage pytest nose pylint pyflakes pycodestyle ];

  # ignore tests which try to write files
  checkPhase = ''
    pytest -k 'not added_file_pylint_console and not file_does_not_exist'
  '';

  meta = with stdenv.lib; {
    description = "Automatically find diff lines that need test coverage";
    homepage = https://github.com/Bachmann1234/diff-cover;
    license = licenses.asl20;
    maintainers = with maintainers; [ dzabraev ];
  };
}
