{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "Chameleon";
  version = "3.8.1";

  # tests not included in pypi tarball
  src = fetchFromGitHub {
    owner = "malthe";
    repo = "chameleon";
    rev = version;
    sha256 = "0nf8x4w2vh1a31wdb86nnvlic9xmr23j3in1f6fq4z6mv2jkwa87";
  };

  pythonImportsCheck = [ "chameleon" ];

  meta = with lib; {
    homepage = "https://chameleon.readthedocs.io/";
    description = "Fast HTML/XML Template Compiler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}
