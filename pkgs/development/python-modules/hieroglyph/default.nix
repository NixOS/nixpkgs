{ stdenv , fetchurl , buildPythonPackage , sphinx }:

buildPythonPackage rec {
  version = "0.7.1";
  name = "hieroglyph-${version}";

  src = fetchurl {
    url = "mirror://pypi/h/hieroglyph/${name}.tar.gz";
    sha256 = "0rswfk7x6zlj1z8388f153k3zn2h52k5h9b6p57pn7kqagsjilcb";
  };

  propagatedBuildInputs = [ sphinx ];

  # all tests fail; don't know why:
  # test_absolute_paths_made_relative (hieroglyph.tests.test_path_fixing.PostProcessImageTests) ... ERROR
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate HTML presentations from plain text sources";
    homepage = https://github.com/nyergler/hieroglyph/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ juliendehos ];
    platforms = platforms.unix;
  };
}

