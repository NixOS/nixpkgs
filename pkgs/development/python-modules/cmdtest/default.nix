{ stdenv
, buildPythonPackage
, fetchurl
, cliapp
, ttystatus
, markdown
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  pname = "cmdtest";
  version = "0.32";
  disabled = isPy3k || isPyPy;

  src = fetchurl {
    url = "http://code.liw.fi/debian/pool/main/c/cmdtest/cmdtest_${version}.orig.tar.xz";
    sha256 = "0scc47h1nkmbm5zlvk9bsnsg64kb9r4xadchdinf4f1mph9qpgn6";
  };

  propagatedBuildInputs = [ cliapp ttystatus markdown ];

  # TODO: cmdtest tests must be run before the buildPhase
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://liw.fi/cmdtest/;
    description = "Black box tests Unix command line tools";
    license = licenses.gpl3;
  };

}
