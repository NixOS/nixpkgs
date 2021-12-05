{ lib, fetchPypi, buildPythonPackage, lxml, docopt, six, pytestCheckHook, mock
}:

buildPythonPackage rec {
  pname = "rnginline";
  version = "0.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-j4W4zwHA4yA6iAFVa/LDKp00eeCX3PbmWkjd2LSUGfk=";
  };

  propagatedBuildInputs = [ lxml docopt six ];

  checkInputs = [ pytestCheckHook mock ];

  # Those tests does not succeed, a test dependency is likely missing but nothing is specified upstream
  disabledTestPaths =
    [ "rnginline/test/test_cmdline.py" "rnginline/test/test_rnginline.py" ];

  meta = {
    description =
      "A Python library and command-line tool for loading multi-file RELAX NG schemas from arbitary URLs, and flattening them into a single RELAX NG schema";
    homepage = "https://github.com/h4l/rnginline";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.lesuisse ];
  };
}
