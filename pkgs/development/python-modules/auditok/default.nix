{ lib
, buildPythonPackage
, fetchPypi
, matplotlib
, numpy
, pyaudio
, pydub
, tqdm
}:

buildPythonPackage rec {
  pname = "auditok";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RsUS4oey4T30gZd0FmrzKyNtdUr75rDchygbIz5a5og=";
  };

  propagatedBuildInputs = [ matplotlib numpy pyaudio pydub tqdm ];

  meta = with lib; {
    description =
      "Audio Activity Detection tool that can process online data as well as audio files";
    homepage = "https://github.com/amsehili/auditok/";
    license = licenses.mit;
    maintainers = with maintainers; [ arguggi ];
  };
}
