{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  babel,
  humanize,
  python-dateutil,
  pytz,
  tzlocal,
}:

buildPythonPackage (finalAttrs: {
  pname = "delorean";
  version = "1.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "Delorean";
    inherit (finalAttrs) version;
    hash = "sha256-/md4bhIzhSOEi+xViKZYxNQl4S1T61HP74cL7I9XYTQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    babel
    humanize
    python-dateutil
    pytz
    tzlocal
  ];

  pythonImportsCheck = [ "delorean" ];

  # test data not included
  doCheck = false;

  meta = {
    description = "Delorean: Time Travel Made Easy";
    homepage = "https://github.com/myusuf3/delorean";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
