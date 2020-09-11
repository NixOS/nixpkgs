{ lib
, buildPythonPackage
, fetchPypi
, python
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2020.7.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a3af27a8d23143c49a3420efe5b3f8cf1a48c6fc8bc6856b03f638abc1833bb";
  };

  postCheck = ''
    echo "We now run tests ourselves, since the setuptools installer doesn't."
    ${python.interpreter} -c 'import test_regex; test_regex.test_main();'
  '';

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}
