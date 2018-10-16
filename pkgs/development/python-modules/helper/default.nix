{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, pyyaml
}:

buildPythonPackage rec {
  pname = "helper";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e33dde42ad4df30fb7790689f93d77252cff26a565610d03ff2e434865a53a2";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ pyyaml ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Development library for quickly writing configurable applications and daemons";
    homepage = https://helper.readthedocs.org/;
    license = licenses.bsd3;
  };

}
