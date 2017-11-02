{ lib
, buildPythonPackage
, fetchPypi
, pytest
, sphinx
, CommonMark_54
, docutils
}:

buildPythonPackage rec {
  pname = "recommonmark";
  name = "${pname}-${version}";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e29c723abcf5533842376d87c4589e62923ecb6002a8e059eb608345ddaff9d";
  };

  checkInputs = [ pytest sphinx ];
  propagatedBuildInputs = [ CommonMark_54 docutils ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "A docutils-compatibility bridge to CommonMark";
    homepage = https://github.com/rtfd/recommonmark;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}