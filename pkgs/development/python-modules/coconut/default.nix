{ stdenv
, buildPythonPackage
, fetchurl
, prompt-toolkit
, pygments
, pyparsing
}:

buildPythonPackage rec {
  pname = "coconut";
  version = "1.4.0";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/12/44/83d1db0d6a48a16ae53cc7bfa78e21bbccfc9df598fbc9de49a55df02c57/coconut-1.4.0.tar.gz";
    sha256 = "b192c71022702b60b4c8c8dac06321a4a82e21c237ba2bb71d2edebb7540b8a9";
  };

  doCheck = false;

  propagatedBuildInputs = [
    pygments
    prompt-toolkit
    pyparsing
  ];

  meta = with stdenv.lib; {
    homepage = "http://coconut-lang.org";
    license = "Apache-2.0";
    description = "Simple, elegant, Pythonic functional programming.";
    maintainers = with lib.maintainers; [ bbarker ];
  };
}