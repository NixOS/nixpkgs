{ lib
, buildPythonPackage
, fetchFromGitHub
, docutils
, rich
}:

buildPythonPackage rec {
  pname = "rich-rst";
  version = "1.1.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "wasi-master";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g1whhw07jgy46a1x85pd23gs356j1cc229wqf5j3x4r11kin6i5";
  };

  propagatedBuildInputs = [ docutils rich ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "rich_rst" ];

  meta = with lib; {
    description = "A beautiful reStructuredText renderer for rich";
    homepage = "https://github.com/wasi-master/rich-rst";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
