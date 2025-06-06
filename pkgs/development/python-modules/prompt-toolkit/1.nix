{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  docopt,
  six,
  wcwidth,
  pygments,
}:

buildPythonPackage rec {
  pname = "prompt-toolkit";
  version = "1.0.18";

  src = fetchPypi {
    pname = "prompt_toolkit";
    inherit version;
    sha256 = "dd4fca02c8069497ad931a2d09914c6b0d1b50151ce876bc15bde4c747090126";
  };

  propagatedBuildInputs = [
    docopt
    six
    wcwidth
    pygments
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_pathcompleter_can_expanduser" ];

  meta = with lib; {
    description = "Python library for building powerful interactive command lines";
    longDescription = ''
      prompt_toolkit could be a replacement for readline, but it can be
      much more than that. It is cross-platform, everything that you build
      with it should run fine on both Unix and Windows systems. Also ships
      with a nice interactive Python shell (called ptpython) built on top.
    '';
    homepage = "https://github.com/jonathanslenders/python-prompt-toolkit";
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };
}
