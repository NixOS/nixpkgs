{ lib, buildPythonPackage, fetchPypi, tqdm }:

buildPythonPackage rec {
  pname = "ffpb";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7eVqbLpMHS1sBw2vYS4cTtyVdnnknGtEI8190VlXflk=";
  };

  propagatedBuildInputs = [ tqdm ];

  # tests require working internet connection
  doCheck = false;

  meta = with lib; {
    description =
      "ffpb is an FFmpeg progress formatter. It will attempt to display a nice progress bar in the output, based on the raw ffmpeg output, as well as an adaptative ETA timer.";
    homepage = "https://github.com/althonos/ffpb";
    license = licenses.mit;
    maintainers = with maintainers; [ CaptainJawZ ];
  };
}
