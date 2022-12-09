{ lib
, buildPythonPackage
, fetchPypi
, zeroconf
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "moku";
  version = "2.5.1";

  /*

  Pypi's webpage <https://pypi.org/project/moku/> lists
  https://github.com/liquidinstruments/moku/archive/${version}.tar.gz as the
  download link, but that repository doesn't exist from some reason :/. When
  packaging this, I didn't find any mention of a git repo of the sources. Note
  that the pymoku <https://github.com/liquidinstruments/pymoku> repo holds the
  sources of the legacy API package.

  */
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oFRwJ6i4wfjA3E2QMqE4ybutT7OZiFZ3LYXoplY3D/I=";
  };
  /*

  Note: If you run `moku download` and encounter the error:

  [Errno 13] Permission denied: '/nix/store/.../lib/python 3.9/site-packages/moku/data'

  Then use the $MOKU_DATA_PATH environment variable to control where the
  downloaded files will go to. It is undocumented upstream and there's no
  repository to contribute such documentation unfortunately. Also there is no
  suitable default value for this on Nix systems, so there's no patch we can
  apply locally to make the situation better.

  */

  propagatedBuildInputs = [
    zeroconf
    requests
    setuptools
  ];

  pythonImportsCheck = [
    "moku"
  ];

  meta = with lib; {
    description = "Python scripting interface to the Liquid Instruments Moku";
    homepage = "https://apis.liquidinstruments.com/starting-python.html";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
