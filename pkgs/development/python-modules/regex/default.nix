{ lib
, buildPythonPackage
, fetchPypi
, python
}:


buildPythonPackage rec {
  pname = "regex";
  version = "2018.11.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "79a6a60ed1ee3b12eb0e828c01d75e3b743af6616d69add6c2fde1d425a4ba3f";
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
