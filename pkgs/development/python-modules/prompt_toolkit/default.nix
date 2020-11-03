{ lib
, buildPythonPackage
, fetchPypi
, pytest
, six
, wcwidth
}:

buildPythonPackage rec {
  pname = "prompt_toolkit";
  version = "3.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25c95d2ac813909f813c93fde734b6e44406d1477a9faef7c915ff37d39c0a8c";
  };
  checkPhase = ''
    py.test -k 'not test_pathcompleter_can_expanduser'
  '';

  checkInputs = [ pytest ];
  requiredPythonModules = [ six wcwidth ];

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
