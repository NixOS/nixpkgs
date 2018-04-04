{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "contexter";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xrnkjya29ya0hkj8y4k9ni2mnr58i6r0xfqlj7wk07v4jfrkc8n";
  };

  meta = with stdenv.lib; {
  };
}
