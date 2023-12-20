{ buildPythonPackage, lib, fetchFromBitbucket
, parse
}:

buildPythonPackage rec {
  pname = "pyparser";
  version = "1.0";
  format = "setuptools";

  # Missing tests on Pypi
  src = fetchFromBitbucket {
    owner = "rw_grim";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aplb4zdpgbpmaw9qj0vr7qip9q5w7sl1m1lp1nc9jmjfij9i0hf";
  };

  postPatch = "sed -i 's/parse==/parse>=/' requirements.txt";

  propagatedBuildInputs = [ parse ];

  meta = {
    description = "Simple library that makes it easier to parse files";
    homepage = "https://bitbucket.org/rw_grim/pyparser";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
