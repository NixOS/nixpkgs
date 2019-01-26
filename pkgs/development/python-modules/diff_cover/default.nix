{ stdenv, buildPythonPackage, fetchPypi, jinja2, jinja2_pluralize, pygments,
  six, inflect, mock, nose, coverage, pycodestyle, flake8, pyflakes, git,
  pylint, pydocstyle, fetchpatch, glibcLocales }:

buildPythonPackage rec {
  pname = "diff_cover";
  version = "1.0.2";

  preCheck = ''
    export LC_ALL=en_US.UTF-8;
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wbp0kfv2mjxwnq2jlqmwvb71fywwc4x4azxi7ll5dll6nhjyd61";
  };

  patches = [
    (fetchpatch {
      name = "tests-fix.patch";
      url = "https://github.com/Bachmann1234/diff-cover/commit/85c30959c8ed2aa3848f400095a2418f15bb7777.patch";
      sha256 = "0xni4syrxww9kdv8495f416vqgfdys4w2hgf5rdi35hy3ybfslh0";
    })
  ];

  propagatedBuildInputs = [ jinja2 jinja2_pluralize pygments six inflect ];

  checkInputs = [ mock nose coverage pycodestyle flake8 pyflakes pylint pydocstyle git glibcLocales ];

  meta = with stdenv.lib; {
    description = "Automatically find diff lines that need test coverage";
    homepage = https://github.com/Bachmann1234/diff-cover;
    license = licenses.asl20;
    maintainers = with maintainers; [ dzabraev ];
  };
}
