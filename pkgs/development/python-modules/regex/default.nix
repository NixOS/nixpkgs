{ lib
, buildPythonPackage
, fetchPypi
, python
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2020.5.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce450ffbfec93821ab1fea94779a8440e10cf63819be6e176eb1973a6017aff5";
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
