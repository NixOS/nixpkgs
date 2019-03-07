{ lib
, buildPythonPackage
, fetchPypi
# Runtime inputs:
, pyparsing
# Check inputs:
, setuptools
, pytest
, mock
}:

buildPythonPackage rec{
  pname = "pyhocon";
  version = "0.3.51";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10l014br012fa583rnj3wqf6g9gmljamcwpw4snqwwg15i0dmkll";
  };

  propagatedBuildInputs = [ pyparsing ];

  checkInputs = [ setuptools pytest mock ];

  # Tests fail because necessary data files aren't packaged for PyPi yet.
  # See https://github.com/chimpler/pyhocon/pull/203
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/chimpler/pyhocon/;
    description = "HOCON parser for Python";
    # Long description copied from <GitHub>/setup.py on 2019-03-06.
    longDescription = ''
      A HOCON parser for Python. It additionally provides a tool
      (pyhocon) to convert any HOCON content into json, yaml and properties
      format
    '';
    license = licenses.asl20;
    maintainers = [ maintainers.chreekat ];
  };
}
