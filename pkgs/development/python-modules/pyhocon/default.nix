{ lib
, buildPythonPackage
, fetchFromGitHub
# Runtime inputs:
, pyparsing
# Check inputs:
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "pyhocon";
  version = "0.3.53";

  src = fetchFromGitHub {
    owner = "chimpler";
    repo = "pyhocon";
    rev = version;
    sha256 = "1lr56piiasnq1aiwli8ldw2wc3xjfck8az991mr5rdbqqsrh9vkv";
  };

  propagatedBuildInputs = [ pyparsing ];

  checkInputs = [ pytest mock ];

  # Tests fail because necessary data files aren't packaged for PyPi yet.
  # See https://github.com/chimpler/pyhocon/pull/203
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/chimpler/pyhocon/";
    description = "HOCON parser for Python";
    # Long description copied from
    # https://github.com/chimpler/pyhocon/blob/55a9ea3ebeeac5764bdebebfbeacbf099f64db26/setup.py
    # (the tip of master as of 2019-03-24).
    longDescription = ''
      A HOCON parser for Python. It additionally provides a tool
      (pyhocon) to convert any HOCON content into json, yaml and properties
      format
    '';
    license = licenses.asl20;
    maintainers = [ maintainers.chreekat ];
  };
}
