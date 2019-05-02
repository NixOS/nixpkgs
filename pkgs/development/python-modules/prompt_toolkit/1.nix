{ lib
, buildPythonPackage
, fetchPypi
, pytest
, docopt
, six
, wcwidth
, pygments
}:

buildPythonPackage rec {
  pname = "prompt_toolkit";
  version = "1.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c1cedd626e08b8ee830ee65897de754113ff3f3035880030c08b01674d85c5b4";
  };
  checkPhase = ''
    rm prompt_toolkit/win32_types.py
    py.test -k 'not test_pathcompleter_can_expanduser'
  '';

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ docopt six wcwidth pygments ];

  meta = {
    description = "Python library for building powerful interactive command lines";
    longDescription = ''
      prompt_toolkit could be a replacement for readline, but it can be
      much more than that. It is cross-platform, everything that you build
      with it should run fine on both Unix and Windows systems. Also ships
      with a nice interactive Python shell (called ptpython) built on top.
    '';
    homepage = https://github.com/jonathanslenders/python-prompt-toolkit;
    license = lib.licenses.bsd3;
  };
}
