{ lib
, buildPythonPackage
, fetchPypi
, python
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2018.02.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b44624a38d07d3c954c84ad302c29f7930f4bf01443beef5589e9157b14e2a29";
  };

  postCheck = ''
    echo "We now run tests ourselves, since the setuptools installer doesn't."
    ${python.interpreter} -c 'import test_regex; test_regex.test_main();'
  '';

  meta = {
    description = "Alternative regular expression module, to replace re";
    homepage = https://bitbucket.org/mrabarnett/mrab-regex;
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}
