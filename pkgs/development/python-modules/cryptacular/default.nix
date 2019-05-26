{ stdenv, buildPythonPackage, fetchPypi, isPy27, pythonAtLeast
, coverage, nose, pbkdf2 }:

buildPythonPackage rec {
  pname = "cryptacular";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18fl7phl6r9xiwz8f1jpkahkv21wimmiq72gmrqncccv7z806gr7";
  };

  buildInputs = [ coverage nose ];
  propagatedBuildInputs = [ pbkdf2 ];

  # TODO: tests fail: TypeError: object of type 'NoneType' has no len()
  doCheck = false;

  # Python >=2.7.15, >=3.6.5 are incompatible:
  # https://bitbucket.org/dholth/cryptacular/issues/11
  disabled = isPy27 || pythonAtLeast "3.6";

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar ];
  };
}
