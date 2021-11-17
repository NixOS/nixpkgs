{ lib
, python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "python-hglib";
  # https://bugzilla.mozilla.org/show_bug.cgi?id=1741686
  version = "2.6.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-fB+gy00zLdbshAmwR4fOukYj6X+zeGVvfKsLmWxso7I=";
  };

  buildInputs = [
  ];

  # attempts to create a temporary `HGTMP` folder
  doCheck = false;

  pythonImportsCheck = [ "hglib" ];

  meta = with lib; {
    description = "Library with a fast, convenient interface to Mercurial. It uses Mercurial’s command server for communication with hg.";
    homepage = "https://www.mercurial-scm.org/wiki/PythonHglibs";
    license = licenses.mit;
    maintainers = [ maintainers.kvark ];
  };
}
