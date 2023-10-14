{ buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "getpass-asterisk";
  version = "1.0.1";

  src = fetchPypi {
    inherit version;
    pname = "getpass_asterisk";
    sha256 = "1sd99sss404hzp1zsks69q4ck186wgjv8g5p2m7glqng4jlmghvw";
  };

  # TODO FIXME
  doCheck = false;

  meta = {
    description =
      "An alternative implementation for getpass that echoes masked password (such as asterisks)";
    homepage = "https://github.com/secursive/getpass_asterisk";
  };
}
