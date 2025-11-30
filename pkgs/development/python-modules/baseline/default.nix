{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "baseline";
  version = "1.2.1";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "dmgass";
    repo = "baseline";
    rev = "95a0b71806ed16310eb0f27bc48aa5e21f731423";
    sha256 = "0qjg46ipyfjflvjqzqr5p7iylwwqn2mhhrq952d01vi8wvfds10d";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Easy String Baseline";
    mainProgram = "baseline";
    longDescription = ''
      This tool streamlines creation and maintenance of tests which compare
      string output against a baseline.
    '';
    homepage = "https://github.com/dmgass/baseline";
    license = licenses.mit;
    maintainers = with maintainers; [ dnr ];
  };
}
