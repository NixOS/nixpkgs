{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, typer
, dataclasses
, smart-open
, pytest
, mock
, google-cloud-storage
}:

buildPythonPackage rec {
  pname = "pathy";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "838624441f799a06b446a657e4ecc9ebc3fdd05234397e044a7c87e8f6e76b1c";
  };

  propagatedBuildInputs = [ smart-open typer google-cloud-storage ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "smart-open>=2.2.0,<4.0.0" "smart-open>=2.2.0"
  '';

  checkInputs = [ pytestCheckHook mock ];

  # Exclude tests that require provider credentials
  pytestFlagsArray = [
    "--ignore=pathy/_tests/test_clients.py"
    "--ignore=pathy/_tests/test_gcs.py"
    "--ignore=pathy/_tests/test_s3.py"
  ];

  meta = with lib; {
    description = "A Path interface for local and cloud bucket storage";
    homepage = "https://github.com/justindujardin/pathy";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
