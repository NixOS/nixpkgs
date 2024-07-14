{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  path,
  zetup,
  pytest,
  decorator,
}:

buildPythonPackage rec {
  pname = "moretools";
  version = "0.1.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c7BGnU8d9tlnUIEDRz8LFSRwitv/cfj5DvcdmkQiayI=";
  };

  checkPhase = ''
    py.test test
  '';

  nativeBuildInputs = [ zetup ];
  nativeCheckInputs = [
    six
    path
    pytest
  ];
  propagatedBuildInputs = [ decorator ];

  meta = with lib; {
    description = ''
      Many more basic tools for python 2/3 extending itertools, functools, operator and collections
    '';
    homepage = "https://bitbucket.org/userzimmermann/python-moretools";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
