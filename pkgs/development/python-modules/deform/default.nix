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
  setuptools,
  coverage,
  beautifulsoup4,
  flaky,
  pyramid,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "deform";
  version = "2.0.15";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HpEpN2UMHbuDAHndnAOZUHYqIwIjpWd0D78bI/EJA2c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    chameleon
    colander
    iso8601
    peppercorn
    translationstring
    zope-deprecation
  ];

  nativeCheckInputs = [
    coverage
    beautifulsoup4
    flaky
    pyramid
    pytestCheckHook
  ];

  meta = {
    description = "Form library with advanced features like nested forms";
    homepage = "https://docs.pylonsproject.org/projects/deform/en/latest/";
    # https://github.com/Pylons/deform/blob/fdc43d59de7d11b0e3ba1b92835b780cfe181719/LICENSE.txt
    license = [
      lib.licenses.bsd3
      lib.licenses.cc-by-30
    ];
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
