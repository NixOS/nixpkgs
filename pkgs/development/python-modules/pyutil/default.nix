{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  mock,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  simplejson,
  twisted,
  versioneer,
}:

buildPythonPackage rec {
  pname = "pyutil";
  version = "3.3.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XcPWu5xbq6u10Ldz4JQEXXVxLos0ry0psOKGAmaCZ8A=";
  };

  prePatch = lib.optionalString isPyPy ''
    grep -rl 'utf-8-with-signature-unix' ./ | xargs sed -i -e "s|utf-8-with-signature-unix|utf-8|g"
  '';

  nativeBuildInputs = [
    setuptools
    versioneer
  ];

  passthru.optional-dependencies = {
    jsonutil = [ simplejson ];
    # Module not available
    # randcookie = [
    #   zbase32
    # ];
  };

  nativeCheckInputs = [
    mock
    twisted
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "pyutil" ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # https://github.com/tpltnt/pyutil/issues/10
    "test_decimal"
    "test_float"
  ];

  meta = with lib; {
    description = "Collection of mature utilities for Python programmers";
    longDescription = ''
      These are a few data structures, classes and functions which
      we've needed over many years of Python programming and which
      seem to be of general use to other Python programmers. Many of
      the modules that have existed in pyutil over the years have
      subsequently been obsoleted by new features added to the
      Python language or its standard library, thus showing that
      we're not alone in wanting tools like these.
    '';
    homepage = "https://github.com/tpltnt/pyutil";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ prusnak ];
  };
}
