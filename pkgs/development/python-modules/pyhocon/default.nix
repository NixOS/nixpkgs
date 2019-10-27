{ lib
, buildPythonPackage
, fetchPypi
# Runtime inputs:
, pyparsing
# Check inputs:
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "pyhocon";
  version = "0.3.53";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29d9b64d0141d202b77c18665dc4fcafc05fd4c1a4b0fd95ca57c8b58c0e6c2d";
  };

  propagatedBuildInputs = [ pyparsing ];

  checkInputs = [ pytest mock ];

  # Tests fail because necessary data files aren't packaged for PyPi yet.
  # See https://github.com/chimpler/pyhocon/pull/203
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/chimpler/pyhocon/;
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
