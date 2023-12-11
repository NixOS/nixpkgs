{ lib
, attrs
, buildPythonPackage
, colorlog
, csvw
, fetchFromGitHub
, git
, isPy27
, lxml
, markdown
, markupsafe
, mock
, postgresql
, pylatexenc
, pytest-mock
, pytestCheckHook
, python-dateutil
, tabulate
}:

buildPythonPackage rec {
  pname = "clldutils";
  version = "3.19.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "clld";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dva0lbbTxvETDPkACxpI3PPzWh5gz87Fv6W3lTjNv3Q=";
  };

  patchPhase = ''
    substituteInPlace setup.cfg --replace "--cov" ""
  '';

  propagatedBuildInputs = [
    attrs
    colorlog
    csvw
    lxml
    markdown
    markupsafe
    pylatexenc
    python-dateutil
    tabulate
  ];

  nativeCheckInputs = [
    mock
    postgresql
    pytest-mock
    pytestCheckHook
    git
  ];

  disabledTests = [
    # uses pytest.approx which is not supported in a boolean context in pytest7
    "test_to_dec"
    "test_roundtrip"
  ];

  meta = with lib; {
    description = "Utilities for clld apps without the overhead of requiring pyramid, rdflib et al";
    homepage = "https://github.com/clld/clldutils";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
