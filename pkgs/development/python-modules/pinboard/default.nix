{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pinboard";
  version = "2.1.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lionheart";
    repo = pname;
    rev = version;
    sha256 = "0ppc3vwv48ahqx6n5c7d7066zhi31cjdik0ma9chq6fscq2idgdf";
  };

  # tests require an API key
  doCheck = false;

  meta = with lib; {
    description = "A Python wrapper for Pinboard.in";
    mainProgram = "pinboard";
    maintainers = with maintainers; [ djanatyn ];
    license = licenses.asl20;
    homepage = "https://github.com/lionheart/pinboard.py";
  };
}
