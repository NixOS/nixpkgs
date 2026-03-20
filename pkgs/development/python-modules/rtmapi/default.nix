{
  lib,
  buildPythonPackage,
  fetchFromBitbucket,
  setuptools,
  httplib2,
}:

buildPythonPackage rec {
  pname = "rtmapi";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromBitbucket {
    owner = "rtmapi";
    repo = "rtmapi";
    rev = "release-${version}";
    hash = "sha256-+aJ7T5bE+N9bINf6S3v48wUGXQ/ikz1Xb15xWbConT4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    httplib2
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "use_2to3=True," ""
  '';

  # package has no tests
  doCheck = false;

  pythonImportsCheck = [ "rtmapi" ];

  meta = {
    description = "API package for rememberthemilk.com";
    homepage = "https://bitbucket.org/rtmapi/rtmapi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
