{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "imgsize";
  version = "2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ojii";
    repo = pname;
    rev = version;
    sha256 = "0k24qj4i996fz7lpjrs36il6lp51rh13b0j2wip87cy5v9109m2d";
  };

  meta = with lib; {
    description = "Pure Python image size library";
    homepage = "https://github.com/ojii/imgsize";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ twey ];
  };
}
