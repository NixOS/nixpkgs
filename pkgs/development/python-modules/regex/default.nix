{ lib
, buildPythonPackage
, fetchPypi
, python
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2019.02.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "587bd4cad11c7294f89799c45778abca271d7c6668a0e85c41a6dbfa8096f9bb";
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
