{ lib
, buildPythonPackage
, fetchPypi
, enum-compat
, unicodecsv
}:
buildPythonPackage rec {
  pname = "python-registry";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "99185f67d5601be3e7843e55902d5769aea1740869b0882f34ff1bd4b43b1eb2";
  };

  propagatedBuildInputs = [
    enum-compat
    unicodecsv
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "Registry"
  ];

  meta = with lib; {
    description = "Pure Python parser for Windows Registry hives";
    homepage = "https://github.com/williballenthin/python-registry";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
