{ lib
, buildPythonPackage
, fetchPypi
, mercurial
, nose
}:

buildPythonPackage rec {
  pname = "python-hglib";
  version = "2.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sYvR7VPJDuV9VxTWata7crZOkw1K7KmDCJLAi7KNpgg=";
  };

  checkInputs = [ mercurial nose ];

  preCheck = ''
    export HGTMP=$(mktemp -d)
    export HGUSER=test
  '';

  pythonImportsCheck = [ "hglib" ];

  meta = with lib; {
    description = "Library with a fast, convenient interface to Mercurial. It uses Mercurial’s command server for communication with hg.";
    homepage = "https://www.mercurial-scm.org/wiki/PythonHglibs";
    license = licenses.mit;
    maintainers = [];
  };
}
