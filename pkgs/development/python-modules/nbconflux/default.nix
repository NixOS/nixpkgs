{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, nbconvert
, pytestCheckHook
, requests
, responses
}:

buildPythonPackage rec {
  pname = "nbconflux";
  version = "0.7.0";
  disabled = isPy27; # no longer compatible with python 2 urllib

  src = fetchFromGitHub {
    owner = "Valassis-Digital-Media";
    repo = "nbconflux";
    rev = version;
    sha256 = "1708qkb275d6f7b4b5zmqx3i0jh56nrx2n9rwwp5nbaah5p2wwlh";
  };

  propagatedBuildInputs = [ nbconvert requests ];

  nativeCheckInputs = [ pytestCheckHook responses ];

  JUPYTER_PATH="${nbconvert}/share/jupyter";
  disabledTests = [
    "test_post_to_confluence"
    "test_optional_components"
  ];

  meta = with lib; {
    description = "Converts Jupyter Notebooks to Atlassian Confluence (R) pages using nbconvert";
    homepage = "https://github.com/Valassis-Digital-Media/nbconflux";
    license = licenses.bsd3;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
