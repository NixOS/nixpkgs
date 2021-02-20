{ lib
, buildPythonPackage
, fetchPypi
, pytest
, six
, wcwidth
}:

buildPythonPackage rec {
  pname = "prompt_toolkit";
  version = "3.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fa02fa80363844a4ab4b8d6891f62dd0645ba672723130423ca4037b80c1974";
  };
  checkPhase = ''
    py.test -k 'not test_pathcompleter_can_expanduser'
  '';

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six wcwidth ];

  meta = {
    description = "Python library for building powerful interactive command lines";
    longDescription = ''
      prompt_toolkit could be a replacement for readline, but it can be
      much more than that. It is cross-platform, everything that you build
      with it should run fine on both Unix and Windows systems. Also ships
      with a nice interactive Python shell (called ptpython) built on top.
    '';
    homepage = "https://github.com/jonathanslenders/python-prompt-toolkit";
    license = lib.licenses.bsd3;
  };
}
