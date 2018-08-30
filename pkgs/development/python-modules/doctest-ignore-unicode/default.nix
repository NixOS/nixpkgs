{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "doctest-ignore-unicode";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m9aa4qnyj21lbq4sbvmv1vcz7zksss4rz37ddf2hxv4hk8b547w";
  };

  propagatedBuildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Add flag to ignore unicode literal prefixes in doctests";
    license = with licenses; [ asl20 ];
    homepage = https://github.com/gnublade/doctest-ignore-unicode;
  };
}
