{ lib
, buildPythonPackage
, fetchPypi
, docutils
, mistune
, pygments
}:

buildPythonPackage rec {
  pname = "m2r";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf90bad66cda1164b17e5ba4a037806d2443f2a4d5ddc9f6a5554a0322aaed99";
  };

  postPatch = ''
    substituteInPlace tests/test_cli.py \
      --replace "optional" "positional"
  '';

  propagatedBuildInputs = [ mistune docutils ];

  checkInputs = [ pygments ];

  meta = with lib; {
    homepage = "https://github.com/miyakogi/m2r";
    description = "Markdown to reStructuredText converter";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    broken = versionAtLeast mistune.version "2";
  };
}
