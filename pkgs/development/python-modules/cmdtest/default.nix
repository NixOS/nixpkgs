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
  name = "cmdtest-${version}";
  version = "0.18";
  disabled = isPy3k || isPyPy;

  src = fetchurl {
    url = "http://code.liw.fi/debian/pool/main/c/cmdtest/cmdtest_${version}.orig.tar.xz";
    sha256 = "068f24k8ad520hcf8g3gj7wvq1wspyd46ay0k9xa360jlb4dv2mn";
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
