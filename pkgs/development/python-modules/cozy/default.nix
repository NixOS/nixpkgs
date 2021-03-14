{ buildPythonPackage, isPy3k, fetchFromGitHub, lib,
  z3, ply, python-igraph, oset, ordered-set, dictionaries, setuptools }:

buildPythonPackage {
  pname = "cozy";
  version = "2.0a1";
  disabled = !isPy3k;

  propagatedBuildInputs = [
    setuptools z3 ply python-igraph oset ordered-set dictionaries
  ];

  src = fetchFromGitHub {
    owner = "CozySynthesizer";
    repo = "cozy";
    rev = "f553e9b";
    sha256 = "1jhr5gzihj8dkg0yc5dmi081v2isxharl0ph7v2grqj0bwqzl40j";
  };

  # Yoink the Z3 dependency name, because our Z3 package doesn't provide it.
  postPatch = ''
    sed -i -e '/z3-solver/d' -e 's/^dictionaries.*$/dictionaries/' requirements.txt
  '';

  # Tests are not correctly set up in the source tree.
  doCheck = false;
  pythonImportsCheck = [ "cozy" ];

  # There is some first-time-run codegen that we will force to happen.
  postInstall = ''
    $out/bin/cozy --help
  '';


  meta = {
    description = "The collection synthesizer";
    homepage = "https://cozy.uwplse.org/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
