{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, attrs
, colorlog
, csvw
, python-dateutil
, tabulate
, mock
, postgresql
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "clldutils";
  version = "3.9.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "clld";
    repo = pname;
    rev = "v${version}";
    sha256 = "07ljq7v1zvaxyl6xn4a2p4097lgd5j9bz71lf05y5bz8k024mxbr";
  };

  patchPhase = ''
    substituteInPlace setup.cfg --replace "--cov" ""
  '';

  propagatedBuildInputs = [
    python-dateutil
    tabulate
    colorlog
    attrs
    csvw
  ];

  nativeCheckInputs = [
    mock
    postgresql
    pytestCheckHook
    pytest-mock
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
    maintainers = with maintainers; [ ];
  };
}
