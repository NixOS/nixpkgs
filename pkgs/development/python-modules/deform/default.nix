{
  lib,
  buildPythonPackage,
  fetchPypi,
  chameleon,
  colander,
  iso8601,
  peppercorn,
  translationstring,
  zope-deprecation,
  nose,
  coverage,
  beautifulsoup4,
  flaky,
  pyramid,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "deform";
  version = "2.0.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HpEpN2UMHbuDAHndnAOZUHYqIwIjpWd0D78bI/EJA2c=";
  };

  propagatedBuildInputs = [
    chameleon
    colander
    iso8601
    peppercorn
    translationstring
    zope-deprecation
  ];

  nativeCheckInputs = [
    nose
    coverage
    beautifulsoup4
    flaky
    pyramid
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Form library with advanced features like nested forms";
    homepage = "https://docs.pylonsproject.org/projects/deform/en/latest/";
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with maintainers; [ domenkozar ];
  };
}
