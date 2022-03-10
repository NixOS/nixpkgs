{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "growattserver";
  version = "1.2.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "indykoning";
    repo = "PyPi_GrowattServer";
    rev = version;
    sha256 = "0v9clmz4qg6krmbsbfsrhsan824y2mqvwxsxb0fzfgaszxwkpm30";
  };

  propagatedBuildInputs = [
    requests
  ];

  postPatch = ''
    # https://github.com/indykoning/PyPi_GrowattServer/issues/2
    substituteInPlace setup.py \
      --replace "tag = os.environ['LATEST_TAG']" "" \
      --replace "version=tag," 'version="${version}",'
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "growattServer" ];

  meta = with lib; {
    description = "Python package to retrieve information from Growatt units";
    homepage = "https://github.com/indykoning/PyPi_GrowattServer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
