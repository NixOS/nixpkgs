{ lib
, buildPythonPackage
, fetchPypi
, python
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2019.12.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8355eaa64724a0fdb010a1654b77cb3e375dc08b7f592cc4a1c05ac606aa481c";
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
