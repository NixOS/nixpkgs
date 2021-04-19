{ lib, buildPythonPackage, fetchFromPyPI, future }:

buildPythonPackage rec {

  pname = "backports.csv";
  version = "1.0.7";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "0vdx5jlhs91iizc8j8l8811nqprwvdx39pgkdc82w2qkfgzxyxqj";
  };

  propagatedBuildInputs = [ future ];

  meta = with lib; {
    description = "Backport of Python 3 csv module";
    homepage = "https://github.com/ryanhiebert";
    license = licenses.psfl;
  };
}
