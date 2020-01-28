{ lib
, buildPythonPackage
, fetchPypi
, python
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2020.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lc3fzh72w7hqxihf8ixfhj0p5lhki5jwvrv7crb08lqiwr29x6h";
  };

  postCheck = ''
    echo "We now run tests ourselves, since the setuptools installer doesn't."
    ${python.interpreter} -c 'import test_regex; test_regex.test_main();'
  '';

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Alternative regular expression module, to replace re";
    homepage = https://bitbucket.org/mrabarnett/mrab-regex;
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}
