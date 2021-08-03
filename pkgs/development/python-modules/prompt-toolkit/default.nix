{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
, wcwidth
}:

buildPythonPackage rec {
  pname = "prompt-toolkit";
  version = "3.0.19";

  src = fetchPypi {
    pname = "prompt_toolkit";
    inherit version;
    sha256 = "08360ee3a3148bdb5163621709ee322ec34fc4375099afa4bbf751e9b7b7fa4f";
  };

  propagatedBuildInputs = [ six wcwidth ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_pathcompleter_can_expanduser"
  ];

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
