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
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f83f1eddf77dd86e824143eef8d9adbe0785c3cdd5ec0ed6c0edea3227385048";
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
